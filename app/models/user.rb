class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :brackets

  def stripe_customer
    if self.stripe_customer_id.present?
      Stripe::Customer.retrieve(self.stripe_customer_id)
    else
      customer = Stripe::Customer.create(:email => self.email)
      self.stripe_customer_id = customer.id
      self.save!
      customer
    end
  end
end
