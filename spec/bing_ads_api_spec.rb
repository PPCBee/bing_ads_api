require 'spec_helper'

describe BingAdsApi do
  it "comes from a module" do #simple test to init tests
    BingAdsApi.should be_a_kind_of(Module)
  end
end

describe BingAdsApi do
  before(:all) do #once (and could be modified by the following tests)
    $default_customer_id = 'XXXXXX' # fill in with your sandbox credentials
    $default_customer_account_id = 'XXXXXX' # fill in with your sandbox credentials
    Savon.configure do |config|
      config.pretty_print_xml = true
    end
  end
  it "authenticates" do
    lambda{
      $bing_ads = BingAdsApi::Api.new({
         :authentication => {
             :method => 'ClientLogin',
             :developer_token => 'DEVELOPER_TOKEN',
             :password => 'PASSWORD',
             :user_name => 'USERNAME',
             :customer_id => $default_customer_id,
             :customer_account_id => $default_customer_account_id
         },
         :service => {:environment => 'SANDBOX'},
         :library => {:log_level => 'DEBUG'}
      })
    }.should_not raise_error
  end

  context "handles AdministrationService V7: " do
    it "selects the service" do
      lambda{ $admin_srv8 = $bing_ads.service(:AdministrationService, :v8)}.should_not raise_error
    end
    it "get_assigned_quota" do
      $admin_srv8.get_assigned_quota().should be_a_kind_of(Hash)
    end
    it "get_remaining_quota" do
      $admin_srv8.get_remaining_quota().should be_a_kind_of(Hash)
    end
  end

  context "handles CampaignManagementService V7: " do
    it "selects the service" do
      lambda{ $campaign_srv8 = $bing_ads.service(:CampaignManagementService, :v8)}.should_not raise_error
    end
    it "add_campaigns" do
      $campaign_srv8.add_campaigns({:account_id => $default_customer_account_id,
                                    :campaigns => {:campaign => [{:budget_type => "DailyBudgetWithMaximumMonthlySpend",
                                                                  :conversion_tracking_enabled => false,
                                                                  :daily_budget => 5,
                                                                  :daylight_saving => false,
                                                                  :description => "A perfect new campaign",
                                                    :monthly_budget => 50,
                                                    :name => "perfectcampaign",
                                                    :time_zone => "BrusselsCopenhagenMadridParis"}]}}).should be_a_kind_of(Hash)
    end
    it "get_campaigns_by_account_id" do
      $campaign_srv8.get_campaigns_by_account_id({:account_id => $default_customer_account_id}).should be_a_kind_of(Hash)
    end
  end

  context "handles CustomerManagementService V7: " do
    # get_account, add_account, update_account, delete_account
    # get_customers_info, get_customer, update_customer, signup_customer, delete_customer, get_customer_pilot_feature
    # add_user, update_user, update_user_roles, get_user, delete_user, get_users_info
    it "selects the service" do
      lambda{ $customer_srv8 = $bing_ads.service(:CustomerManagementService, :v8)}.should_not raise_error
    end
    it "get_customer" do
      $customer = $customer_srv8.get_customer({:customer_id => $default_customer_id})
      $customer.should be_a_kind_of(Hash)
      puts "$customer=#{$customer}"
    end
    it "get_user" do
      $user = $customer_srv8.get_user({:user_id => '226562'})
      $user.should be_a_kind_of(Hash)
    end
    it "get_accounts_info" do
      $customer_accounts = $customer_srv8.get_accounts_info({:customer_id => $default_customer_id})
      $customer_accounts.should be_a_kind_of(Hash)
    end
    it "get_account" do
      $customer_account = $customer_srv8.get_account({:account_id => $customer_accounts[:accounts_info][:account_info][:id]})
      $customer_account.should be_a_kind_of(Hash)
    end
    #it "get_users_info" do #DOES NOT WORK IN SANDBOX
    #  $users_info = $customer_srv8.get_users_info({:customer_id => $default_customer_id})
    #  $users_info.should be_a_kind_of(Hash)
    #end
    #it "get customers info" do #DOES NOT WORK IN SANDBOX
    #  $customers_infos = $customer_srv8.get_customers_info({})
    #  $customers_infos.should be_a_kind_of(Hash)
    #end
    #it "signup_customer" do #DOES NOT WORK IN SANDBOX
    #  $customer_srv8.signup_customer({:account => {},
    #                                  :application_scope => "Advertiser",
    #                                  :customer => {:id => c[:id], :customer_address => c[:customer_address], :industry => c[:industry], :market => c[:market], :name => c[:name], :time_stamp => c[:time_stamp]},
    #                                  :parent_customer_id => $customer[:customer][:id],
    #                                  :user => {}}).should be_a_kind_of(Hash)
    #end
    #it "update_customer" do #DOES NOT WORK IN SANDBOX
    #  c = $customer[:customer]
    #  $customer_srv8.update_customer({:customer => {:id => c[:id], :customer_address => c[:customer_address], :industry => c[:industry], :market => c[:market], :name => c[:name], :time_stamp => c[:time_stamp]}}).should be_a_kind_of(Hash)
    #end
  end


end
