class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :invitable

  has_many :brackets, dependent: :destroy
  has_many :brackets_to_pay, class_name: "Bracket", foreign_key: "payment_collector_id"
  has_many :pool_users, dependent: :destroy
  has_many :pools, through: :pool_users

  validates :email, format: { with: EmailValidator.regexp }
  validates :name, presence: true

  enum role: %i(regular admin)

  after_create do |user|
    user.welcome_message unless user.invitation_token.present?
  end

  def stripe_customer
    if stripe_customer_id.present?
      Stripe::Customer.retrieve(stripe_customer_id)
    else
      customer = Stripe::Customer.create(email: email)
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
    UserMailer.welcome_message(self).deliver_later
  end
end
