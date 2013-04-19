class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      
      t.integer :profile_id
      t.integer :file_id
      t.integer :zendesk_id
      t.string :old_id
      t.string :external_id
      t.column :type,:enum,limit: [:problem,:incident,:question,:task]
      t.string :subject
      t.text :description
      t.column :priority,:enum,limit: [:urgent,:high,:normal,:low],default: :normal
      t.column :status,:enum,limit: [:new,:open,:pending,:hold,:solved,:closed],default: :new
      t.string :requester_email
      t.integer :requester_id
      t.string :submitter_email
      t.integer :submitter_id
      t.string :assignee_email
      t.integer :assignee_id
      t.string :organization_name
      t.integer :organization_id
      t.string :group_name
      t.integer :group_id
      t.date :due_at
      t.text :tags
      t.column :state,:enum,limit: ['pending','imported','deleted'],default: 'pending'
      t.boolean :error,default: 0
      t.text :report
      t.integer :code
      
      20.times do |i|
        
        t.text 'cf_'+i.to_s
        
      end

      t.timestamps
      
    end
  end
end