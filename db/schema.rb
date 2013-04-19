# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130326064529) do

  create_table "attachments", :force => true do |t|
    t.integer  "profile_id"
    t.enum     "state",      :limit => [:organizations, :users, :groups, :group_memberships, :ticket_comments, :tickets], :default => :organizations
    t.string   "file"
    t.boolean  "open",                                                                                                    :default => true
    t.enum     "status",     :limit => [:ready, :extracting, :complete, :error],                                          :default => :ready
    t.integer  "complete",                                                                                                :default => 0
    t.integer  "total",                                                                                                   :default => 0
    t.boolean  "active",                                                                                                  :default => true
    t.boolean  "locked",                                                                                                  :default => false
    t.datetime "created_at",                                                                                                                          :null => false
    t.datetime "updated_at",                                                                                                                          :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "username"
    t.string   "password"
    t.string   "subdomain"
    t.integer  "user_id"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "conditions", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "map_id"
    t.integer  "field_id"
    t.string   "condition"
    t.string   "field_value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "csv_attempts", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "file_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "csv_errors", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "file_id"
    t.integer  "attempt_id"
    t.text     "alerts"
    t.text     "data"
    t.integer  "row"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "csv_errors", ["profile_id"], :name => "index_csv_errors_on_profile_id"

  create_table "custom_fields", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "client_id"
    t.string   "display_name"
    t.boolean  "required",      :default => false
    t.boolean  "solve",         :default => false
    t.text     "field_type"
    t.text     "field_options"
    t.integer  "rel"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "custom_roles", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "client_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "desk_cases", :force => true do |t|
    t.integer  "zendesk_id"
    t.integer  "desk_id"
    t.integer  "priority"
    t.string   "subject"
    t.integer  "group_id"
    t.string   "group_name"
    t.integer  "user_id"
    t.string   "user_name"
    t.text     "description"
    t.integer  "customer_id"
    t.string   "case_status_type"
    t.text     "labels"
    t.string   "import_status"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "groups", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "file_id"
    t.integer  "zendesk_id"
    t.string   "old_id"
    t.boolean  "pulled",                                                :default => false
    t.string   "name"
    t.enum     "state",      :limit => [:pending, :imported, :deleted], :default => :pending
    t.boolean  "error",                                                 :default => false
    t.text     "report"
    t.integer  "code"
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
  end

  add_index "groups", ["name"], :name => "index_groups_on_name"
  add_index "groups", ["profile_id"], :name => "index_groups_on_profile_id"

  create_table "import_attempts", :force => true do |t|
    t.integer  "profile_id"
    t.enum     "state",      :limit => [:organizations, :users, :groups, :group_memberships, :ticketcomments, :tickets]
    t.boolean  "active",                                                                                                 :default => true
    t.datetime "created_at",                                                                                                               :null => false
    t.datetime "updated_at",                                                                                                               :null => false
  end

  create_table "keys", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "attachment_id"
    t.string   "header"
    t.integer  "field_id"
    t.boolean  "custom_field",  :default => false
    t.integer  "rel"
    t.boolean  "active",        :default => true
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "m_actions", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "map_id"
    t.string   "atype"
    t.integer  "field_id"
    t.integer  "field_2_id"
    t.string   "field_val"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "maps", :force => true do |t|
    t.integer  "profile_id"
    t.string   "name"
    t.string   "m_type"
    t.string   "data_type"
    t.integer  "field_1"
    t.string   "val_1"
    t.integer  "field_2"
    t.string   "val_2"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "organizations", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "file_id"
    t.integer  "zendesk_id"
    t.string   "old_id"
    t.boolean  "pulled",                                                     :default => false
    t.string   "external_id"
    t.string   "name"
    t.text     "domain_name"
    t.text     "details"
    t.text     "notes"
    t.boolean  "shared_tickets"
    t.boolean  "shared_comments"
    t.text     "tags"
    t.boolean  "active",                                                     :default => true
    t.enum     "state",           :limit => [:pending, :imported, :deleted], :default => :pending
    t.boolean  "error",                                                      :default => false
    t.text     "report"
    t.integer  "code"
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
  end

  add_index "organizations", ["name"], :name => "index_organizations_on_name"
  add_index "organizations", ["profile_id"], :name => "index_organizations_on_profile_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "source"
    t.string   "destination"
    t.enum     "state",         :limit => [:organizations, :users, :groups, :group_memberships, :ticketcomments, :tickets], :default => :organizations
    t.integer  "step",                                                                                                      :default => 2
    t.boolean  "organizations",                                                                                             :default => true
    t.boolean  "users",                                                                                                     :default => true
    t.boolean  "groups",                                                                                                    :default => true
    t.enum     "status",        :limit => [:new, :opened, :running, :completed, :deleted],                                  :default => :new
    t.string   "action"
    t.boolean  "locked",                                                                                                    :default => false
    t.boolean  "synced",                                                                                                    :default => false
    t.boolean  "active",                                                                                                    :default => true
    t.datetime "created_at",                                                                                                                            :null => false
    t.datetime "updated_at",                                                                                                                            :null => false
  end

  create_table "ticket_comments", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "file_id"
    t.string   "ticket_id"
    t.string   "ticket_comment_id"
    t.integer  "zendesk_id"
    t.integer  "old_id"
    t.string   "author_email"
    t.integer  "author_id"
    t.text     "value"
    t.string   "public"
    t.boolean  "active"
    t.string   "cdate"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "ticket_comments", ["ticket_id"], :name => "ticket_id"

  create_table "tickets", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "file_id"
    t.integer  "zendesk_id"
    t.string   "old_id"
    t.boolean  "pulled",                                                                        :default => false
    t.string   "external_id"
    t.enum     "t_type",            :limit => [:problem, :incident, :question, :task]
    t.string   "subject"
    t.text     "description"
    t.string   "priority"
    t.enum     "status",            :limit => [:new, :open, :pending, :hold, :solved, :closed], :default => :new
    t.string   "requester_email"
    t.integer  "requester_id"
    t.string   "submitter_email"
    t.integer  "submitter_id"
    t.string   "assignee_email"
    t.integer  "assignee_id"
    t.string   "organization_name"
    t.integer  "organization_id"
    t.string   "group_name"
    t.integer  "group_id"
    t.date     "due_at"
    t.text     "tags"
    t.enum     "state",             :limit => [:pending, :imported, :deleted],                  :default => :pending
    t.boolean  "error",                                                                         :default => false
    t.text     "report"
    t.integer  "code"
    t.text     "cf_0"
    t.text     "cf_1"
    t.text     "cf_2"
    t.text     "cf_3"
    t.text     "cf_4"
    t.text     "cf_5"
    t.text     "cf_6"
    t.text     "cf_7"
    t.text     "cf_8"
    t.text     "cf_9"
    t.text     "cf_10"
    t.text     "cf_11"
    t.text     "cf_12"
    t.text     "cf_13"
    t.text     "cf_14"
    t.text     "cf_15"
    t.text     "cf_16"
    t.text     "cf_17"
    t.text     "cf_18"
    t.text     "cf_19"
    t.string   "cdate"
    t.string   "created_at",                                                                    :default => "",       :null => false
    t.datetime "updated_at",                                                                                          :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.enum     "role",            :limit => [:admin, :agent, :"end-user"], :default => :admin
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
  end

  create_table "zd_users", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "file_id"
    t.integer  "zendesk_id"
    t.string   "old_id"
    t.boolean  "pulled",                                                                           :default => false
    t.string   "external_id"
    t.string   "name"
    t.string   "alias"
    t.boolean  "active",                                                                           :default => true
    t.boolean  "verified",                                                                         :default => true
    t.string   "locale_id"
    t.string   "time_zone"
    t.string   "email"
    t.string   "phone"
    t.text     "identities"
    t.text     "signature"
    t.text     "details"
    t.text     "notes"
    t.string   "organization_name"
    t.integer  "organization_id"
    t.enum     "role",                  :limit => [:"end-user", :admin, :agent],                   :default => :"end-user"
    t.string   "custom_role_name"
    t.integer  "custom_role_id"
    t.boolean  "moderator"
    t.enum     "ticket_restriction",    :limit => [:organization, :groups, :assigned, :requested]
    t.boolean  "only_private_comments"
    t.text     "tags"
    t.boolean  "suspended"
    t.enum     "state",                 :limit => [:pending, :imported, :deleted],                 :default => :pending
    t.boolean  "error",                                                                            :default => false
    t.text     "report"
    t.integer  "code"
    t.datetime "created_at",                                                                                                :null => false
    t.datetime "updated_at",                                                                                                :null => false
  end

  add_index "zd_users", ["email"], :name => "index_zd_users_on_email"
  add_index "zd_users", ["profile_id", "email"], :name => "Email Match"
  add_index "zd_users", ["profile_id"], :name => "index_zd_users_on_profile_id"

  create_table "zendesk_fields", :force => true do |t|
    t.string   "state"
    t.string   "db_name"
    t.string   "display_name"
    t.boolean  "required"
    t.boolean  "custom_field",    :default => false
    t.integer  "custom_field_id"
    t.boolean  "active"
    t.boolean  "visible"
    t.boolean  "map",             :default => true
    t.boolean  "zendesk",         :default => true
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

end
