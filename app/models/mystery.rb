class Mystery < ApplicationRecord

  has_many :mystery_partners, dependent: :destroy, foreign_key: :mystery_id
  has_many :employees, through: :mystery_partners

  scope :active, -> { where(status: true) }
  scope :search_by_id, -> (employee_id) { where(id: employee_id) }
  scope :search_by_status, -> (status) { where(status: status) }
  scope :search_by_month, -> (month_name) { where(month: month_name) }
  scope :search_by_year, -> (year) { where('extract(year  from created_at) = ?', year) }
  scope :search_by_employee_name, -> (employee_name) { where(employees: { name: employee_name }).pluck(:id) }
  scope :search_by_employee_department, -> (employee_department) { where(employees: { department: employee_department }).pluck(:id) }
  scope :this_month, -> { where('created_at BETWEEN ? AND ?', DateTime.now.in_time_zone.beginning_of_month, DateTime.now.in_time_zone.end_of_month) }
  scope :past_groups_till_now, -> (date) { where('valid_till >= ?', date )}
  scope :latest_on_top, -> { order(id: :desc) }

  #Here applying filters to the mystery index page
  def self.filter_results(params)
    mysteries = Mystery.all.latest_on_top.includes(:employees).page(params[:page])
    mysteries = mysteries.search_by_id(params[:mystery_id]) unless params[:mystery_id].blank?
    mysteries = mysteries.search_by_status(params[:status]) unless params[:status].blank?
    mysteries = mysteries.search_by_month(params[:mystery_month]) unless params[:mystery_month].blank?
    mysteries = mysteries.search_by_year(params[:mystery_year]) unless params[:mystery_year].blank?

    mysteries_ids = []
    mysteries_ids << mysteries.search_by_employee_name(params[:employee_name]) unless params[:employee_name].blank?
    mysteries_ids << mysteries.search_by_employee_department(params[:employee_department]) unless params[:employee_department].blank?
    mysteries = mysteries.search_by_id(mysteries_ids) unless mysteries_ids.empty?
    mysteries
  end

  #Creating mystery lunch for specifc months
  def self.mystery_lunches(month)
    date = Date.parse(month)
    valid_till = (date + 3.months - 1.day)
    create_mystery_lunches(date, month, valid_till)
  end

  #Removing older mystery lunches
  def self.remove_older_current_mysteries
    employee_count = Employee.all.count
    Mystery.includes(:employees, :mystery_partners).active.limit(employee_count/2).order('id desc').destroy_all
  end

  private

  #This function actually creates the mystery lunches of specifc month
  def self.create_mystery_lunches(date, month, valid_till)
    old_mystery_partners = []
    (Mystery.includes(:employees, :mystery_partners).active.past_groups_till_now(date)).each do |old_mysteries|
      old_mystery_partners << old_mysteries.mystery_partners.pluck(:employee_id)
    end
    old_mystery_partners.reject(&:blank?)

    # old_mystery_partners = MysteryPartner.joins(:mystery).merge(Mystery.active.past_three_month).group(:mystery_id).pluck(:employee_id)

    employee_hash = {}
    Employee.all.each {|employee| employee_hash[employee.id] = [employee.name, employee.department] }
    count = employee_count = employee_hash.count
    (0...employee_count / 2).each do

      mystery = Mystery.create(month: month, valid_till: valid_till)

      employee_count = employee_hash.count
      first_employee_id = employee_hash.keys.sample
      (first_emp_name, first_emp_department) = employee_hash[first_employee_id]
      employee_hash.delete(first_employee_id)

      #----- Function Checking Department should be different and become partners before or not -------
      employee_hash.select do |second_employee_id, second_employee_data|
        if ((employee_count - 1) == employee_hash.count)
          flag = false
          old_mystery_partners.each do |partners|
            if ((partners.include? first_employee_id) and (partners.include? second_employee_id))
              flag = true
            end
          end
          if flag == false and first_emp_department != second_employee_data[1]
            MysteryPartner.create([
                                    { employee_id: first_employee_id, mystery_id: mystery.id },
                                    { employee_id: second_employee_id, mystery_id: mystery.id }
                                  ])
            employee_hash.delete(second_employee_id)
          end
        end
      end
      #-------------------------------------------------------------------------------------------------
    end
    #--- special case for odd employee ----
    if employee_hash.count == 1 and (count % 2 != 0)
      add_third_partner((count),employee_hash,old_mystery_partners)
    elsif employee_hash.count >= 1
      puts "Recursive Case"
      puts employee_hash
      remove_older_current_mysteries
      create_mystery_lunches(date, month, valid_till)
    end
    #--------------------------------------

  end

  #This adds a third wheeler in a group :)
  def self.add_third_partner(employees_count, employee_hash, old_mystery_partners)
    third_employee_id, (third_emp_name, third_emp_department) = employee_hash.shift
    Mystery.includes(:employees, :mystery_partners).active.limit(employees_count/2).order('id desc').each do |mystery|
      unless mystery.mystery_partners.empty?
        first_employee_id = mystery.mystery_partners.first.employee_id
        second_employee_id = mystery.mystery_partners.last.employee_id
        flag = false
        old_mystery_partners.each do |partners|
          if ((partners.include? third_employee_id) and (partners.include? second_employee_id)) or ((partners.include? third_employee_id) and (partners.include? first_employee_id))
            flag = true
          end
        end
        if flag == false and mystery.employees.first.department != third_emp_department[1] and mystery.employees.last.department != third_emp_department[1]
          MysteryPartner.create({ employee_id: third_employee_id, mystery_id: mystery.id })
          return
        end
      end
    end
  end

end
