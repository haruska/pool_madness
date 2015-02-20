class Pool
  include ActiveAttr::Model

  attribute :tip_off_attr

  TIP_OFF = DateTime.new(2015, 3, 20, 12, 0, 0, "-4")

  def tip_off
    tip_off_attr || TIP_OFF
  end

  def started?
    DateTime.now > tip_off
  end

  def start_eliminating?
    DateTime.now > tip_off + 4.days
  end

  def self.tip_off
    Pool.new.tip_off
  end

  def self.started?
    Pool.new.started?
  end

  def self.start_eliminating?
    Pool.new.start_eliminating?
  end
end
