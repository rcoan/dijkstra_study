class Vertex
  attr_accessor :neighboors, :distance_from_start

  attr_reader :terrain_dificulty

  def initialize(terrain_dificulty: , distance_from_start: Float::INFINITY)
    @neighboors = []
    @distance_from_start = distance_from_start
    @terrain_dificulty = terrain_dificulty
  end
end

class Edge
  attr_reader :vertex, :distance

  def initialize(vertex:, distance:)
    @vertex = vertex
    @distance = distance
  end
end

class Proccess
  attr_accessor :vertex_map

  def self.call(map)
    new.call(map)
  end

  def call(map)
    populate_vertex_map(map)
    generate_edges
    shortest_path
  end

  def populate_vertex_map(positions_map)
    @vertex_map = []

    positions_map.each_with_index do |row, row_index|
      new_row = []
      row.each_with_index do |terrain_dificulty, item_index|
        if row_index.zero? && item_index.zero?
          new_row.push(
            Vertex.new(
              terrain_dificulty: terrain_dificulty,
              distance_from_start: 0
            )
          )
        else
          new_row.push(Vertex.new(terrain_dificulty: terrain_dificulty))
        end
      end
      @vertex_map.push(new_row)
    end
  end

  def generate_edges
    # every block next to 11 will be linked
    #
    # |  -1,-1 | -1,0 |  0,+1 |
    # |   0,-1 |  XX  |  0,+1 |
    # |  +1,-1 | +1,0 | +1,+1 |

    @vertex_map.each_with_index do |row, row_index|
      row.each_with_index do |vertex, vertex_index|
        next if row_index + 1 == @vertex_map.size && vertex_index + 1 == row.size

        # right
        if vertex_index + 1 < row.size
          connect_to(vertex, @vertex_map[row_index][vertex_index + 1])
        end

        # bottom
        if row_index + 1 < @vertex_map.size
          connect_to(vertex, @vertex_map[row_index+1][vertex_index])
        end

        # bottom right
        if row_index + 1 < @vertex_map.size  && vertex_index + 1 < row.size
          connect_to(vertex, @vertex_map[row_index+1][vertex_index+1])
        end
      end
    end
  end

  def connect_to(vertex, next_vertex)
    vertex.neighboors.push(
      Edge.new(
        vertex: next_vertex,
        distance: next_vertex.terrain_dificulty
      )
    )
  end

  def shortest_path
    @vertex_map.each do |row|
      row.each do |vertex|
        vertex.neighboors.each do |edge|
          relative_distance = edge.distance + vertex.distance_from_start
          if relative_distance < edge.vertex.distance_from_start
            edge.vertex.distance_from_start = relative_distance
          end
        end
      end
    end

    @vertex_map.last.last
  end
end
