class Pool
  TIP_OFF = DateTime.new(2014, 3, 20, 12, 0, 0, '-4')

  def self.started?
    DateTime.now > TIP_OFF
  end

  def self.start_eliminating?
    DateTime.now > TIP_OFF + 4.days
  end
end
