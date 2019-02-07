namespace :import_def_scope_data do
  desc "TODO"
  task store_data: :environment do
  	puts "DATA STORING IN PROCESS"
  	require 'csv'
	  @file_names = Dir.entries(Rails.root.join("remote_files"))
    @file_names.each do |file_name|
      @main_file = file_name  if file_name.include? "FACTDATA_"
    end

    @file = Rails.root.join('remote_files',@main_file)
    @org_file = Rails.root.join('remote_files',"DTagy.txt")
    @loc_file = Rails.root.join('remote_files',"DTloc.txt")
    @eduction_file = Rails.root.join('remote_files',"DTedlvl.txt")
    @wage_level =Rails.root.join('remote_files',"DTsallvl.txt")
    @occupation = Rails.root.join('remote_files',"DTocc.txt")


    @soc_code = Rails.root.join("FedSecOCCtoSOCSheet1.csv")


    @lines = File.readlines(@file)

    @lines[0].split(",").each_with_index do |heading, index|
      @agysub = index  if heading  == "AGYSUB"
      @loc = index if heading == "LOC"
      @edlvl = index if heading == "EDLVL"
      @occ = index if heading == "OCC" 
      @sallvl = index if heading == "SALLVL"
      @yearly_wage = index if heading == "SALARY"
      @data_date = index if heading == "DATECODE"
    end 

    @lines.each_with_index  do |line, index|
      unless  index == 0
        @yearwage = FedSopeData.new
        #  GET ORGANISATION FILE

        @yearwage.organization = get_organisation(line,@org_file).titleize.html_safe rescue nil
        #  GET LOCATION FILE
        @yearwage.state = get_location(line, @loc_file).titleize.html_safe  rescue nil
        #  GET EDUCTION LEVEL
        if get_education_level(line,@eduction_file).html_safe  ==  "BACHELOR'S DEGREE"
        	@level = "Bachelor's"
        elsif get_education_level(line,@eduction_file).html_safe  ==  "HIGH SCHOOL GRADUATE OR CERTIFICATE OF EQUIVALENCY"
        	@level = "High School"
        elsif get_education_level(line,@eduction_file).html_safe == "MASTER'S DEGREE"
        	@level = "Master's"
        elsif get_education_level(line,@eduction_file).html_safe == "ASSOCIATE DEGREE"
        	@level = "Associate's"
        elsif get_education_level(line,@eduction_file).html_safe == "DOCTORATE DEGREE"
        	@level = "Doctorate"
        else
        	@level = get_education_level(line,@eduction_file).titleize.html_safe 
        end	
        							
        @yearwage.education_level = @level  rescue nil
        #  GET SOC CODE
        @yearwage.soc_code = get_soc_codes(line, @soc_code,index).kind_of?(Array) ? "" : get_soc_codes(line, @soc_code,index) rescue nil
        #  GET WAGE LEVEL
        @yearwage.wage_level = get_wage_level(line,@wage_level) rescue nil
        #  GET YEARLY WAGE
        @yearwage.yearly_wage = get_yearly_wage(line,@yearly_wage) rescue nil
        # GET OCCUPATIONS
        @yearwage.occupation = get_occupations(line, @occupation).titleize.html_safe  rescue nil
        
        # ADD DATA IN HASH
        @attribute_hash = Hash.new

        @lines[0].split(",").each_with_index do |heading, index|
          if heading == "LOS\r\n"
            @attribute_hash = @attribute_hash.merge(heading.chop => line.split(",")[index].chop)
          else
          @attribute_hash = @attribute_hash.merge(heading => line.split(",")[index])
          end
        end
        # ADD DATA DATE
        @yearwage.data_date = get_data_date(line, @data_date) rescue nil


        @yearwage.data = @attribute_hash  rescue nil
        @yearwage.save
      end

      break if index == 10000

    end
    puts "DATA STORING COMPLETED"
  end


  def get_organisation line, file
    @organisation = line.split(",")[@agysub] 
    @orgs = File.readlines(file)
    @orgs[0].split(",").each_with_index do |heading, index_org| 
      @agysub_found = index_org  if heading  == "AGYSUB" 
      @agysub_value = index_org if heading == "AGYSUBT\r\n" 
    end

    @orgs.each_with_index do |org, index_org| 
      unless  index_org == 0 
        if @organisation == org.split(",")[@agysub_found] 
        	if org.split(",").count == 6
          	return org.split(",")[@agysub_value].chop.gsub(@organisation+"-","") rescue nil 
          else
          	return org.split(/,"(.*)"/)[1].gsub(@organisation+"-","") rescue nil 
        	end
        end 
      end 
    end 
  end

  def get_location line, file
    @location = line.split(",")[@loc] 
    @locations = File.readlines(file)
    @locations[0].split(",").each_with_index do |heading, index_loc| 
      @loc_found = index_loc  if heading  == "LOC" 
      @loc_value = index_loc if heading == "LOCT\r\n" 
    end 

    @locations.each_with_index do |loc, index_loc| 
      unless  index_loc == 0 
        if @location == loc.split(",")[@loc_found] 
          return loc.split(",")[@loc_value].chop.gsub(@location+"-","") rescue nil 
        end 
      end 
    end 
  end

  def get_education_level line, file
    @educt_level = line.split(",")[@edlvl] 
    @eductions = File.readlines(file)
    @eductions[0].split(",").each_with_index do |heading, index_ed| 
      @educt_found = index_ed  if heading  == "EDLVL" 
      @educt_value = index_ed if heading == "EDLVLT\r\n" 
    end 

    @eductions.each_with_index do |educt, index_ed| 
      unless  index_ed == 0 
        if @educt_level == educt.split(",")[@educt_found] 
          return educt.split(",")[@educt_value].chop.gsub(@educt_level+"-","") rescue nil 
        end 
      end 
    end 
  end

  def get_wage_level line, file
    @year_wage = line.split(",")[@sallvl] 
    @yearly_wages = File.readlines(file)
    @yearly_wages[0].split(",").each_with_index do |heading, index_yw| 
      @yearly_found = index_yw  if heading  == "SALLVL" 
      @yearly_value = index_yw if heading == "SALLVLT\r\n" 
    end 

    @yearly_wages.each_with_index do |year_wage, index_yw| 
      unless  index_yw == 0 
        if @year_wage == year_wage.split(",")[@yearly_found] 
          return year_wage.chop.split(/,"(.*)"/)[1] rescue nil 
        end 
      end 
    end 
  end

  def get_soc_codes line, file, index
    @soc = line.split(",")[@occ] 
    csv_text = File.read(file) 
    @soc_codes = CSV.parse(csv_text) 

    @soc_codes[0].each_with_index do |heading, index_soc| 
      @soc_found = index_soc  if heading  == "OPM CODE" 
      @soc_value = index_soc if heading == "SOC CODE" 
    end 
    @soc_codes.each_with_index do |soc_code, index_soc|
      unless  index_soc == 0 
        if @soc.to_i == soc_code[@soc_found].to_i 
          return soc_code[@soc_value] rescue nil 
        end
      end
    end
  end

  def get_occupations line, file
    @occupation_occ = line.split(",")[@occ] 
    @occupations = File.readlines(file)
    # @occupations[0].split(",").each_with_index do |heading, index_occ| 
    #   @occ_found = index_occ  if heading  == "OCC" 
    #   @occ_value = index_occ if heading == "OCCT\r\n" 
    # end 
    @occupations.each_with_index do |loc, index_loc| 
      unless  index_loc == 0 
        # if @occupation_occ == loc.split(",")[@occ_found]
        #   debugger
        #   return loc.split(",")[@occ_value].chop.gsub(@occupation_occ+"-","") rescue nil
        # end 
        occupation_val =  loc.split(/(.*),\d+,/).last.chop.split("-")[0].gsub!(/[^0-9A-Za-z]/, '').nil? ? loc.split(/(.*),\d+,/).last.chop.split("-")[0] : loc.split(/(.*),\d+,/).last.chop.split("-")[0].gsub!(/[^0-9A-Za-z]/, '')
        
        if @occupation_occ == occupation_val
          return loc.split(/(.*),\d+,/).last.chop.split("-")[1] rescue nil
        end
      end 
    end
  end

  def get_yearly_wage(line,salary)
    return line.chop.split(",")[salary] rescue 0
  end

  def get_data_date(line, data_date)
    return line.chop.split(",")[data_date] rescue 0
  end
end