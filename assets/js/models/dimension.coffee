@services.factory 'Dimension', () ->
  class Dimension
    constructor: (@fact, @reduceCallback) ->
      @filterCallback = null
      @counts = {}          # count of all known records, by reduce function
      @filteredCounts = {}  # count of filtered records, by reduce function
      @list = []            # counts, summarized as a list
      @length = 0

    setRecords: (records) =>
      counts = {}
      @reduce(records, counts)
      @buildList(counts)
      @length = _.size(counts)
      @counts = counts
    
    all: () =>
      @list

    filterAll: =>
      @filteredRecords = null
      @fact.applyDimensions()

    filter: (callback) => 
      @filterCallback = callback
      @filteredRecords = _.filter(@fact.records, callback)
      @fact.applyDimensions()

   
    # private

    reduce: (records, counts=@counts) =>
      for record in records 
        @reduceCallback record, (signature) =>
          counts[signature] ||= 0
          counts[signature] += 1

    buildList: (counts) =>
      list = []
      for signature, count of counts
        list.push {key: signature, value: count}
      @list = list

  Dimension