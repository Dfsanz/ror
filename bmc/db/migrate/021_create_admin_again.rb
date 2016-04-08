class CreateAdminAgain < ActiveRecord::Migration
  def self.up
  	  		 admin_user = User.create(:username => 'diego', 
                             :email => 'dsanz@sanzconsulting.com',
                             :profile => 'Site Administrator',
                             :password => 'project358', 
                             :password_confirmation => 'project358')
    admin_role = Role.find_by_name('Administrator')
    admin_user.roles << admin_role
  end

  def self.down
  end
end
