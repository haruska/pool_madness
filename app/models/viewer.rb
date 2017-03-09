class Viewer
  ID = "VIEWER".freeze

  def self.find(id)
    return new if id == ID
  end

  def id
    Viewer::ID
  end
end
