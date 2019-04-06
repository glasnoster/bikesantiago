class ComunaCreator
  attr_reader :client

  RM = "Región Metropolitana de Santiago"

  def self.from_file(path)
    client = OpenStruct.new(list_comunas: RGeo::GeoJSON.decode(File.open(path).read))

    ComunaCreator.new(client)
  end

  def initialize(client)
    @client = client
  end

  def create_comunas!
    comunas = client.list_comunas
    comunas.each do |comuna|
      comuna_name = comuna.property("NOM_REG")
      next if comuna_name != RM
      create_comuna(comuna_name, comuna.geometry)
    end
  end

  private
  def create_comuna(name, geometry)
    Comuna.create(
      name:   name,
      bounds: geometry)
  end

end