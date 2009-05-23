Given /^Shawn Balestracci is a team scheduler$/ do
  u=Factory(:user, :first_name => 'Shawn', :last_name => 'Balestracci', :email => 'b723176@madison.k12.wi.us')
  @school.team_schedulers.create!(:user => u)
end

