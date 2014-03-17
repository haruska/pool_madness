class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :brackets
  has_many :brackets_to_pay, :class_name => 'Bracket', :foreign_key => 'payment_collector_id'

  has_many :charges, :through => :brackets

  after_create do |user|
    user.welcome_message unless user.invitation_token.present?
  end

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

  # devise_invitable accept_invitation! method overriden
  def accept_invitation!
    welcome_message
    super
  end

  def welcome_message
    UserMailer.welcome_message(self).deliver
  end
end
