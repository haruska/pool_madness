class Pool < ActiveRecord::Base
  belongs_to :tournament
  has_many :brackets

  delegate :tip_off, to: :tournament

  #FIXME: remove
  def self.started?
    first.started?
  end

  def started?
    DateTime.now > tip_off
  end

  def start_eliminating?
    DateTime.now > tip_off + 4.days
  end
end
