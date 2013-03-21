class Pool
  TIP_OFF = DateTime.new(2013, 3, 21, 12, 0, 0, '-4')

  def self.started?
    DateTime.now > TIP_OFF
  end
end
