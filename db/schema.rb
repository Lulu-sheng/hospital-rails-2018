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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180424144714) do

  create_table "doctors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "specialty"
    t.date "received_license"
    t.bigint "mentor_id"
    t.index ["mentor_id"], name: "index_doctors_on_mentor_id"
  end

  create_table "employee_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email"
    t.float "salary", limit: 24
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "employee_type"
    t.bigint "employee_id"
    t.index ["employee_type", "employee_id"], name: "index_employee_records_on_employee_type_and_employee_id"
  end

  create_table "nurse_assignments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "patient_id"
    t.bigint "nurse_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nurse_id"], name: "index_nurse_assignments_on_nurse_id"
    t.index ["patient_id"], name: "index_nurse_assignments_on_patient_id"
  end

  create_table "nurses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean "night_shift"
    t.integer "hours_per_week"
    t.date "date_of_certification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.date "admitted_on"
    t.string "emergency_contact"
    t.string "blood_type"
    t.bigint "doctor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "room_id"
    t.index ["doctor_id"], name: "index_patients_on_doctor_id"
    t.index ["room_id"], name: "index_patients_on_room_id"
  end

  create_table "rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "wing"
    t.integer "floor"
    t.integer "number"
    t.boolean "vip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "patients", "doctors"
  add_foreign_key "patients", "rooms"
end
