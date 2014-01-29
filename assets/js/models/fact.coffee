@services.factory 'Fact', (Dimension) ->
  class Fact
    constructor: (facts) ->
      @records = []
      @filteredRecords = []
      @dimensions = {}
      @length = 0
      @add(facts) if facts

    add: (records) =>
      @records = @records.concat(records)
      # for name, dimension of @dimensions
      #   dimension.add(records)
      @length += records.length
      @applyDimensions()

    group: (name, reduce) =>
      dimension = new Dimension(@, reduce)
      @dimensions[name] = dimension
      @[name] = dimension
      dimension

    all: () =>
      @filteredRecords

    # used by dimensions

    applyDimensions: () =>
      a = moment()
      filtered = {all: @records}
      intersection = @records
      for name, dimension of @dimensions
        intersection = _.intersection(intersection, dimension.filteredRecords)  if dimension.filteredRecords

      @filteredRecords = intersection
      dimension.setRecords(intersection) for name, dimension of @dimensions

      console.log "#{moment()-a}"

    size: () ->
      @filteredRecords.length

  Fact