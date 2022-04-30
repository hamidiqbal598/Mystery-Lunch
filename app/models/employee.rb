class Employee < ApplicationRecord

  #Specific departments we've listed in Input file
  DEPARTMENTS = ['operations', 'sales', 'marketing', 'risk','management','finance','HR','development','data']

  has_one_attached :photo
  has_many :mystery_partners
  has_many :mysteries, through: :mystery_partners

  scope :search_by_id, -> (employee_id) { where(id: employee_id) }
  scope :search_by_name, -> (employee_name) { where('lower(name) = ?', employee_name.downcase) }
  scope :search_by_department, -> (employee_department) { where(department: employee_department) }
  scope :latest_on_top, -> { order(id: :desc) }

  # after_create :add_current_month_lunch
  validates :name, presence: true
  validates :department, presence: true

  # Here applying filters for index
  def self.filter_results(params)
    employees = Employee.all.page(params[:page])
    employees = employees.search_by_id(params[:employee_id]) unless params[:employee_id].blank?
    employees = employees.search_by_name(params[:employee_name]) unless params[:employee_name].blank?
    employees = employees.search_by_department(params[:employee_department]) unless params[:employee_department].blank?
    employees
  end

  # Add new employee to this month mystery lunch
  def add_current_month_lunch

    month = Date.today.strftime("%B")
    valid_till = (Date.parse(month) + 3.months - 1.day)
    employees_count = Employee.all.count

    Mystery.includes(:employees, :mystery_partners).active.limit(employees_count/2).order('id desc').each do |mystery|
      if employees_count % 2 != 0
        #even
        flag = true
        mystery.employees.each do |employee|
          if employee.department == self.department
            flag = false
          end
        end
        if flag == true
          MysteryPartner.create({ employee_id: self.id, mystery_id: mystery.id })
          return true
        end
      else
        #odd
        if (mystery.mystery_partners.length == 3)
          new_mystery = Mystery.create(month: month, valid_till: valid_till)
          mystery.employees.each do |employee|
            if employee.department != self.department
              MysteryPartner.find_by(employee_id: employee.id, mystery_id: mystery.id).delete
              MysteryPartner.create([
                                      { employee_id: self.id, mystery_id: new_mystery.id },
                                      { employee_id: employee.id, mystery_id: new_mystery.id }
                                    ])
              return true
            end
          end

        end
      end
    end

  end

end
