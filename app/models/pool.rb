class Pool < ActiveRecord::Base
  belongs_to :tournament
  has_many :brackets
  has_many :bracket_points, through: :brackets
  has_many :pool_users
  has_many :users, through: :pool_users

  delegate :tip_off, to: :tournament

  validates :invite_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: { scope: :tournament_id }

  before_validation :set_invite_code

  def started?
    DateTime.now > tip_off
  end

  def start_eliminating?
    DateTime.now > tip_off + 4.days
  end

  def admins
    pool_users.admin.map(&:user)
  end

  def total_collected
    credit_card = brackets.paid.where(payment_collector_id: nil).count * entry_fee * 0.94
    cash = brackets.paid.where.not(payment_collector_id: nil).count * entry_fee

    (credit_card.to_i + cash) / 1000 * 10
  end

  private

  def set_invite_code
    self.invite_code = generate_unique_code if invite_code.blank?
  end

  def generate_unique_code
    code = nil

    loop do
      code = SecureRandom.urlsafe_base64(5).upcase.gsub(/[^A-Z0-9]/, "")
      break unless Pool.find_by(invite_code: code).present?
    end

    code
  end
end
