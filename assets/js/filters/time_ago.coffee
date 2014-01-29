@filters.filter 'timeAgo', ->
  (text, exp, comp) ->
    if text
      value = moment(text).fromNow()
      if (exp == "short")
        value = value.
            replace(" seconds", "s").
            replace(" second", "s").
            replace(" minutes", "m").
            replace(" minute", "m").
            replace(" hours", "h").
            replace(" hour", "h").
            replace(" days", "d").
            replace(" day", "d").
            replace(" months", "mo").
            replace(" month", "mo").
            replace(" years", "yr").
            replace(" year", "yr")
      value
    else
      ""