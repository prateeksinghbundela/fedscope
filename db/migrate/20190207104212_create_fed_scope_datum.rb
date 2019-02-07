class CreateFedScopeDatum < ActiveRecord::Migration[5.0]
  def up
    create_table :fed_scope_datum do |t|
      t.string :organization
      t.string :state
      t.string :education_level
      t.string :occupation
      t.string :soc_code
      t.string :yearly_wage
      t.string :wage_level
      t.string :data_date
      t.jsonb :data
      t.timestamps
    end
  end
  def down
    drop_table :fed_scope_datum
  end
end