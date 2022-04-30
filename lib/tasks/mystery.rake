namespace :mystery do

  desc "update mystery lunch in database every start of month"
  task mystery_lunches: :environment do

    Mystery.mystery_lunches(Date.today.strftime("%B"))
    # Mystery.mystery_lunches("May")

  end

end
