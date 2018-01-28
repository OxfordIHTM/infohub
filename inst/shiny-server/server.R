################################################################################
#
# Server function
#
################################################################################
#
# Set Shiny options
#
options(shiny.maxRequestSize = 70 * 1024 ^ 2)
options(shiny.usecairo = FALSE)
#
#
#
function(input, output, session) {
  #
  # Read uploaded data
  #
  survey.dataset <- reactive({
    #
    # Use pre-loaded data if no dataset is uploaded
    #
    inputFile <- input$file1
    #
    #
    #
    if(is.null(inputFile)) { current.data }
    #
    # If dataset is uploaded...
    #
    else
      {
      #
      # Read dataset file
      #
      temp <- read.csv(file = inputFile$datapath, header = TRUE, sep = ",")
      #
      #
      #
      temp <- temp[order(temp$indicatorCode), ]
      }
  })
  #
  # Read uploaded data
  #
  survey.indicators <- reactive({
    #
    # Use pre-loaded data if no dataset is uploaded
    #
    inputFile <- input$file1a
    #
    #
    #
    if(is.null(inputFile)) { current.indicators }
    #
    # If dataset is uploaded...
    #
    else
      {
      #
      # Read dataset file
      #
      temp <- read.csv(file = inputFile$datapath, header = TRUE, sep = ",")
      }
  })
  #
  #
  #
  output$current.data.table <- DT::renderDataTable(
	#
	#
    #
    survey.dataset()[ , c("country", "month", "year", "indicatorName", 
                          "strata", "type", "estimate", "LCL", "UCL")], 
    #
    #
    #
    options = list(pageLength = 10)
  )  
  #
  #
  #
  output$current.indicators.table <- DT::renderDataTable(
	#
	#
    #
    survey.indicators(), 
    #
    #
    #
    options = list(pageLength = 10)
  )  
  #
  # Update country select input based on survey dataset uploaded
  #
  observe({
    updateSelectInput(session = session,
      inputId = "country",
      label = "Country",
      choices = list(Select = ".", unique(survey.dataset()$country)),
      selected = "."
    )
  })
  #
  # Update country select input based on survey dataset uploaded
  #
  observe({
    updateSelectInput(session = session,
      inputId = "country",
      label = "Country",
      choices = list(Select = ".", unique(survey.dataset()$country)),
      selected = "."
    )
  })
  #
  # Update city select input based on country/ies in dataset
  #
  observe({
    #
    # Bangladesh
    #
    if(input$country == "Bangladesh")
      #
      #
      #
      updateSelectInput(session,
                        inputId = "city",
                        label = "City",
                        choices = c(Select = ".", 
                                    "Dhaka" = "Dhaka"))
    #
    # Ghana
    #
    if(input$country == "Ghana")
      #
      #
      #
      updateSelectInput(session,
                        inputId = "city",
                        label = "City",
                        choices = c(Select = ".",
                                    "Accra" = "Accra"))    
    # 
    # Kenya
    #
    if(input$country == "Kenya")
      #
      #
      #
      updateSelectInput(session,
                        inputId = "city",
                        label = "City",
                        choices = c(Select = ".",
                                    "Nakuru" = "Nakuru"))    
    #
    # Madagascar
    #
    if(input$country == "Madagascar")
      #
      #
      #
      updateSelectInput(session,
                        inputId = "city",
                        label = "City",
                        choices = c(Select = ".",
                                    "Antananarivo" = "Antananarivo"))    
    #
    # Mozambique
    #
    if(input$country == "Mozambique")
      #
      #
      #
      updateSelectInput(session,
                        inputId = "city",
                        label = "City",
                        choices = c(Select = ".",
                                    "Maputo" = "Maputo"))
    #
    # Zambia
    #
    if(input$country == "Zambia")
      #
      #
      #
      updateSelectInput(session,
                        inputId = "city",
                        label = "City",
                        choices = c(Select = ".",
                                    "Lusaka" = "Lusaka"))
  })
  #
  # Subset steerIndicators to current city and country
  #
  steer.indicators <- eventReactive(input$country != ".", {
    #
    #
    #
    steerIndicators[steerIndicators[[input$country]] == 1, ]
  })
  #
  #
  #
  vars <- reactive({
    #
    # Create indicator choices for dropdown
    #
    temp <- as.character(steer.indicators()$varList)
    names(temp) <- steer.indicators()$varShort
    #
    #
    #
    return(temp)
  })
  #
  #
  #
  sets <- reactive({
    #
    #
    #
    temp <- as.character(unique(steerIndicators$varSet))
    names(temp) <- unique(steerIndicators$varTitle)
    #
    #
    #
    return(temp)
  })
  #
  #
  #
  observe({
	#
	#
	#
	if(input$city != "."){
	  #
	  #
	  #
	  updateSelectInput(session = session,
	    inputId = "varSet",
	    label = "Select indicator set",
	    choices = c("Select" = ".", sets()),
	    selected = ".")
	}
  })
  #
  #
  #
  observe({
    #
    #
    #
    updateSelectInput(session = session,
	  inputId = "varList",
	  label = "Select indicator",
	  choices = c("Select" = ".",
				  vars()[as.character(steer.indicators()$varShort)[steer.indicators()$varSet == input$varSet]]),
	  selected = ".")
  })
  #
  #
  #
  observeEvent(input$varList != input$varList, {
    #
    #
    #
    updateSelectInput(session = session,
      inputId = "group.by",
      label = "Disaggregate by",
      choices = list(None = ".",
                     "Survey Area" = "surveyArea",
                     "City Corporation" = "corporation",
                     "Wealth Quintile" = "wealth"),
      selected = ".")
  })
  #
  #
  #
  observeEvent(input$varList != input$varList, {
    #
    #
    #
    updateSelectInput(session = session,
      inputId = "facet.by",
      label = "Stratify by",
      choices = list(None = ".",
                     "Area Type" = "type"),
      selected = ".")
  })
  #
  # Update years select input based on survey dataset uploaded
  #
  observe({
    updateSelectInput(session = session,
      inputId = "start.year",
      label = "From",
      choices = unique(survey.dataset()$year)
    )
  })
  #
  # Update years select input based on survey dataset uploaded
  #
  observe({
    updateSelectInput(session = session,
      inputId = "end.year",
      label = "To",
      choices = unique(survey.dataset()$year)[unique(survey.dataset()$year) >= input$start.year]
    )
  })
  #
  #
  #
  sub.data <- reactive({
    #
    #
    #
    subset(survey.dataset(),
           subset = country == input$country & 
                    year >= input$start.year & year <= input$end.year &
                    indicatorCode == input$varList)
  })
  #
  #
  #
  output$current.sub.table <- DT::renderDataTable(
	#
	#
    #
    sub.data()[ , c("country", "month", "year", "strata", "type", "estimate", "LCL", "UCL")], 
    #
    #
    #
    options = list(pageLength = 10)
  )
  #
  #
  #
  sub.indicators <- reactive({
    #
    #
    #
    subset(survey.indicators(),
           subset = country == input$country & 
                    year >= input$start.year & year <= input$end.year)
  })
  #
  #
  #
  output$current.sub.indicators <- DT::renderDataTable(
	#
	#
	#
	options = list(pageLength = 10),
	#
	#
    #
	if(input$varList %in% c("waterSource", "water10", "water11b", "san1", "san3", "san35a", "san28a"))
	  {
	  #
	  #
      #
      sub.indicators()[ , c("uniqueID", "country", "psu", "zone", "type", "month", "year", "corporation", input$varList)]
      }
    #
    #
    #
    else
	  {
	  #
	  #
	  #
	  temp <- subset(sub.indicators(), select = grepl(input$varList, names(sub.indicators())))
	  #
	  #
	  #
	  zone <- NULL
	  corporation <- NULL
	  type <- NULL
	  pQuintile <- NULL
	  indicator <- NULL
	  #
	  #
	  #
	  for(i in 1:ncol(temp))
		{
		#
		#
		#
		zone <- c(zone, sub.indicators()$zone)
		#
		#
		#
		corporation <- c(corporation, sub.indicators()$corporation)
		#
		#
		#
		type <- c(type, sub.indicators()$type)
		#
		#
		#
		pQuintile <- c(pQuintile, sub.indicators()$pQuintile)
		#
		#
		#
		indicator <- c(indicator, as.character(temp[ , i]))
		}
	  #
	  #
	  #
	  paretoDF <- data.frame(zone, corporation, type, pQuintile, indicator)
	  #
	  #
	  #
	  paretoDF$zone <- paste("Survey Area ", paretoDF$zone, sep = "")
	  #
	  #
	  #
	  paretoDF$type <- ifelse(paretoDF$type == 1, "Low Income Area", "Citwyide")
	  #
	  #
	  #
	  paretoDF$pQuintile <- paste("Wealth Quintile ", paretoDF$pQuintile, sep = "")
	  #
	  #
      #
      paretoDF <- paretoDF[!is.na(paretoDF$indicator), ]
	  #
	  #
	  #
	  paretoDF
      }
  )
  #
  #
  #
  ladder.data <- reactive({
    #
    #
    #
    subset(survey.dataset(),
           subset = country == input$country & 
                    year >= input$start.year & year <= input$end.year &
                    indicatorCode %in% steer.indicators()$varList[steer.indicators()$varSet == input$varSet])                    
  })
  #
  #
  #
  output$panel.header <- reactive({
    #
    #
    #
    paste(input$city, ", ", input$country, sep = "")
  })
  #
  #
  #
  output$indicator.header <- reactive({
    #
    #
    #
    paste(steer.indicators()$varNames[steer.indicators()$varList == input$varList])
  })
  #
  #
  #
  output$year.header <- reactive({
    #
    #
    #
    if(input$start.year == input$end.year)
      {
      paste(input$start.year, sep = "")
      }
    #
    #
    #
    else
      {
      paste(input$start.year, " - ", input$end.year, sep = "")
      }
  })
  #
  #
  #
  year.header <- reactive({
    #
    #
    #
    if(input$start.year == input$end.year)
      {
      paste(input$start.year, sep = "")
      }
    #
    #
    #
    else
      {
      paste(input$start.year, " - ", input$end.year, sep = "")
      }
  })
                                       


################################################################################
#
# Dynamic UI
#
################################################################################
  #
  #
  #
  output$overall.estimate <- reactive({
    #
    #
    #
    temp <- subset(sub.data(), 
	  			   strata == "Overall" & 
				   type == "Citywide")
    #
    #
    #
    estimate <- paste(round(temp$estimate[temp$strata == "Overall" & temp$type == "Citywide"] * 100, digits = 1), "%", sep = "")
    #
    # If varList is not proportion...
    #
    if(input$varList %in% steer.indicators()$varList[steer.indicators()$varFunction != "proportion"])
	  {
	  #
	  #
	  #
	  estimate <- paste(round(temp$estimate[temp$strata == "Overall" & temp$type == "Citywide"], digits = 1), sep = "")
	  }
    #
    #
    #
    estimate
  })
  #
  #
  #
  output$ci.estimate <- reactive({
    #
    #
    #
    temp <- subset(sub.data(),
                   strata == "Overall" &
                   type == "Citywide")
    #
    #
    #
    ci <- paste("95% CI: ", 
                round(temp$LCL[temp$strata == "Overall" & temp$type == "Citywide"] * 100, digits = 1), "%",
                " - ",
                round(temp$UCL[temp$strata == "Overall" & temp$type == "Citywide"] * 100, digits = 1), "%",
                sep = "")
    #
    #
    #
    if(input$varList %in% steer.indicators()$varlist[steer.indicators()$varFunction != "proportion", ])
      {
      #
      #
      #
      ci <- paste("95% CI: ", 
                  round(temp$LCL[temp$strata == "Overall" & temp$type == "Citywide"], digits = 1),
                  " - ",
                  round(temp$UCL[temp$strata == "Overall" & temp$type == "Citywide"], digits = 1),
                  sep = "")
      }
    #
    #
    #
    ci
  })
  #
  #
  #
  output$error.bar <- renderUI({
    #
    #
    #
    if(input$varList != "." & 
       !input$varList %in% c("waterSource", "water9", "water10", "water11b", "san1", "san3", "san8", "san20", "san22", "san24", "san35a", "san28a") & 
       input$group.by != "." | input$facet.by != ".")
      {
      #
      #
      #
      checkboxInput(inputId = "error.bar", 
                    label = "Error bars",
                    value = FALSE)
      }
  })
  #
  #
  #
  output$city.table.header <- reactive({
    #
    #
    #
    paste("Sampling List: ", input$var.city.area, " - ", input$city.area.name)
  })
  #
  #
  #
  output$slum1.table.header <- reactive({
    #
    #
    #
    paste("Sampling List: ", input$var.slum.area1, " - ", input$slum.area.name1)
  })
  #
  #
  #
  output$slum2.table.header <- reactive({
    #
    #
    #
    paste("Sampling List: ", input$var.slum.area2, " - ", input$slum.area.name2)
  })

  
################################################################################
#
# Plot indicators
#
################################################################################
  #
  #
  #
  output$bar.plot <- renderPlot({
    #
    #
    #
    temp <- subset(sub.data(), 
                   strata == "Overall" & 
                   type == "Citywide")
    #
    #
    #
    if(input$group.by == "surveyArea" & input$facet.by == ".")
      {
      #
      #
      #
      temp <- subset(sub.data(), 
                     !strata %in% c(paste("Wealth Quintile ", 1:5, sep = ""), "Overall", "North City Corporation", "South City Corporation") &
                     type == "Citywide")
      }
    #
    #
    #
    if(input$group.by == "surveyArea" & input$facet.by == "type")
      {
      #
      #
      #
      temp <- subset(sub.data(), 
                     !strata %in% c(paste("Wealth Quintile ", 1:5, sep = ""), "Overall", "North City Corporation", "South City Corporation"))
      }
    #
    #
    #
    if(input$group.by == "wealth" & input$facet.by == ".")
      {
      #
      #
      #
      temp <- subset(sub.data(), 
                     strata %in% paste("Wealth Quintile ", 1:5, sep = "") &
                     type == "Citywide")
      }
    #
    #
    #
    if(input$group.by == "wealth" & input$facet.by == "type")
      {
      #
      #
      #
      temp <- subset(sub.data(), 
                     strata %in% paste("Wealth Quintile ", 1:5, sep = ""))
      } 
    #
    #
    #
    if(input$group.by == "corporation" & input$facet.by == ".")
      {
      #
      #
      #
      temp <- subset(sub.data(), 
                     strata %in% c("North City Corporation", "South City Corporation") &
                     type == "Citywide")
      }
    #
    #
    #
    if(input$group.by == "corporation" & input$facet.by == "type")
      {
      #
      #
      #
      temp <- subset(sub.data(), 
                     strata %in% c("North City Corporation", "South City Corporation"))
      }
    #
    #
    #
    if(input$group.by == "." & input$facet.by == "type")
      {
      #
      #
      #
      temp <- subset(sub.data(), 
                     strata == "Overall")
      } 
    #
    #
    #
    basePlot <- ggplot(data = temp,
                       mapping = aes(x = strata,
                                     y = estimate))
    #
    #
    #
    barPlot <- geom_bar(stat = "identity", 
                        position = "dodge",
                        alpha = 0.6,
                        fill = input$chart.colour,
                        colour = input$chart.colour)
    #
    #
    #
    barCI <- geom_crossbar(mapping = aes(ymin = LCL, ymax = UCL), 
                           width = 0.5, 
                           size = 0.75, 
                           fatten = 3, 
                           colour = input$error.colour)
    #
    #
    #
    if(input$facet.by != ".")
      {
      #
      #
      #
      barFacet <- facet_grid(facets = . ~ type)
      }
    #
    # y-axis labels
    #
    yLabel <- labs(y = ifelse(input$varList %in% c("water12", "san14", "overallSpend", "san17", "san34") & input$country == "Bangladesh", "Bangladeshi Taka (BDT)",
                         ifelse(input$varList %in% c("water12", "san14", "overallSpend", "san17", "san34") & input$country == "Ghana", "Ghanaian Cedi (GHS)",
                           ifelse(input$varList %in% c("water12", "san14", "overallSpend", "san17", "san34") & input$country == "Kenya", "Kenyan Shillings (KSH)",
                             ifelse(input$varList %in% c("water12", "san14", "overallSpend", "san17", "san34") & input$country == "Madagascar", "Malagasy Ariary (MGA)",
                               ifelse(input$varList %in% c("water12", "san14", "overallSpend", "san17", "san34") & input$country == "Mozambique", "Mozambican Metical (MZN)",
                                 ifelse(input$varList %in% c("water12", "san14", "overallSpend", "san17", "san34") & input$country == "Zambia", "Zambian Kwacha (ZMK)",
                                   ifelse(input$varList %in% c("san13", "water7"), "No. of Minutes", 
                                     ifelse(input$varList == "pQuintile", "Quintiles",
                                       ifelse(input$varList == "ppi", "PPI",
                                         ifelse(input$varList == "water4", "No. of Hours",
                                           ifelse(input$varList == "water5", "No. of Days",
                                             ifelse(input$varList == "san2", "No. of People",
                                               ifelse(input$varList == "acceptScore", "Sanitation Score",
                                                 ifelse(input$varList == "nMembers", "No. of Household Members", "Proportion")))))))))))))))
    #
    # x-axis labels
    #
    xLabel <- labs(x = ifelse(input$group.by == "surveyArea", "Survey Area",
                         ifelse(input$group.by == "wealth", "Wealth Quintile",
                           ifelse(input$facet.by == "type", "Area Type", ""))))
    #
    #
    #
    indicator.plot <- basePlot + barPlot + theme_wsup + yLabel + xLabel
    #
    #
    #
    if(input$group.by == "." & input$facet.by == ".")
      {
      #
      #
      #
      crossBar <- geom_crossbar(data = temp,
                                mapping = aes(ymin = LCL, ymax = UCL),
                                width = 0.25,
                                size = 0.5,
                                fatten = 5,
                                colour = input$chart.colour)
      #
      #
      #
      pointBar <- geom_pointrange(mapping = aes(ymin = LCL, ymax = UCL),
                                  size = 2,
                                  fatten = 5,
                                  colour = input$chart.colour)
      #
      #
      #
      estText <- annotate(geom = "text", 
                          x = temp$strata, 
                          y = temp$estimate + 0.01, 
                          label = temp$estimate,
                          size = 8)
      #
      #
      #
      lclText <- annotate(geom = "text", 
                          x = temp$strata, 
                          y = temp$LCL, 
                          label = temp$LCL,
                          size = 5)
      #
      #
      #
      uclText <- annotate(geom = "text", 
                          x = temp$strata, 
                          y = temp$UCL, 
                          label = temp$UCL,
                          size = 5)
      #
      #
      #
      indicator.plot <- basePlot + crossBar + theme_wsup + yLabel + xLabel
      }
    #
    #
    #
    if(input$varList %in% steer.indicators()$varList[steer.indicators()$varFunction == "proportion"])
      {
      #
      #
      #
      indicator.plot <- indicator.plot + ylim(c(0,1))
      }
    #
    #
    #
    if(input$varList == "ppi")
      {
      #
      #
      #
      indicator.plot <- indicator.plot + ylim(c(0,100))
      }
    #
    #
    #
    if(input$varList == "pQuintile")
      {
      #
      #
      #
      indicator.plot <- indicator.plot + ylim(c(0,5))
      }
    #
    #
    #  
    if(input$facet.by != "." & input$varList != ".")
      {
      #
      # 
      #
      indicator.plot <- indicator.plot + barFacet
      }
    #
    #
    #
    if(input$group.by != ".")
      {
      #
      #
      #
      indicator.plot <- indicator.plot + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
      }
    #
    #
    #
    if(!is.null(input$error.bar) & input$group.by != "." | input$facet.by != ".")
      {
      #
      #
      #
      if(input$error.bar)
        {
        #
        #
        #
        indicator.plot <- indicator.plot + barCI
        }
      }
  #
  #
  #
  if(input$varSet %in% c("waterSet1", "sanSet1", "handSet", "overallSet1") & input$varList == ".")
    {
    #
    #
    #
    temp <- subset(ladder.data(), 
                   strata == "Overall" & 
                   type == "Citywide")
    #
    #
    #
    if(input$group.by == "surveyArea" & input$facet.by == ".")
      {
      #
      #
      #
      temp <- subset(ladder.data(), 
                     strata %in% paste("Survey Area ", 1:9, sep = "") &
                     type == "Citywide")
      }
    #
    #
    #
    if(input$group.by == "surveyArea" & input$facet.by == "type")
      {
      #
      #
      #
      temp <- subset(ladder.data(), 
                     strata %in% paste("Survey Area ", 1:9, sep = ""))
      }
    #
    #
    #
    if(input$group.by == "corporation" & input$facet.by == ".")
      {
      #
      #
      #
      temp <- subset(ladder.data(), 
                     strata %in% c("North City Corporation", "South City Corporation") &
                     type == "Citywide")
      }
    #
    #
    #
    if(input$group.by == "corporation" & input$facet.by == "type")
      {
      #
      #
      #
      temp <- subset(ladder.data(), 
                     strata %in% c("North City Corporation", "South City Corporation"))
      }
    #
    #
    #
    if(input$group.by == "wealth" & input$facet.by == ".")
      {
      #
      #
      #
      temp <- subset(ladder.data(), 
                     strata %in% paste("Wealth Quintile ", 1:5, sep = "") &
                     type == "Citywide")
      }
    #
    #
    #
    if(input$group.by == "wealth" & input$facet.by == "type")
      {
      #
      #
      #
      temp <- subset(ladder.data(), 
                     strata %in% paste("Wealth Quintile ", 1:5, sep = ""))
      } 
    #
    #
    #
    if(input$group.by == "." & input$facet.by == "type")
      {
      #
      #
      #
      temp <- subset(ladder.data(), 
                     strata == "Overall")
      } 
    #
    #
    #
    basePlot <- ggplot(data = temp,
                       mapping = aes(x = strata,
                                     y = estimate,
                                     fill = rev(indicatorCode)))
    #
    #
    #
    barPlot <- geom_bar(stat = "identity", 
                        position = "fill",
                        alpha = 0.6)
    #
    #
    #
    if(input$varSet == "waterSet1" & !is.null(ladder.data()$jmpWater5))
      {
      #
      #
      #
      barFill <- scale_fill_manual(name = "Drinking Water Ladder",
                                   labels = c("Safely-managed",
                                              "Basic",
                                              "Limited",
                                              "Unimproved",
                                              "Surface Water"),
                                   values = waterLadder)
      }
    #
    #
    #
    if(input$varSet == "waterSet1" & is.null(ladder.data()$jmpWater5))
      {
      #
      #
      #
      barFill <- scale_fill_manual(name = "Drinking Water Ladder",
                                   labels = c("Basic",
                                              "Limited",
                                              "Unimproved",
                                              "Surface Water"),
                                   values = waterLadder[2:5])
      }
    #
    #
    #
    if(input$varSet == "sanSet1" & !is.null(ladder.data()$jmpSan5))
      {
      #
      #
      #
      barFill <- scale_fill_manual(name = "Sanitation Ladder",
                                   labels = c("Safely-managed",
                                              "Basic",
                                              "Limited",
                                              "Unimproved",
                                              "Open defecation"),
                                   values = sanitationLadder)
      }
    #
    #
    #
    if(input$varSet == "sanSet1" & is.null(ladder.data()$jmpSan5))
      {
      #
      #
      #
      barFill <- scale_fill_manual(name = "Sanitation Ladder",
                                   labels = c("Basic",
                                              "Limited",
                                              "Unimproved",
                                              "Open defecation"),
                                   values = sanitationLadder[2:5])
      }
    #
    #
    #
    if(input$varSet == "handSet")
      {
      #
      #
      #
      barFill <- scale_fill_manual(name = "Handwashing Ladder",
                                   labels = c("Basic",
                                              "Limited",
                                              "No facility"),
                                   values = handwashLadder)
      }
    #
    #
    #
    if(input$varSet == "overallSet1")
      {
      #
      #
      #
      barFill <- scale_fill_manual(name = "Services Access",
                                   labels = c("Adequate water and sanitation",
                                              "Adequate water only",
                                              "Adequate sanitation only",
                                              "No access to adequate services"),
                                   values = rev(overallColour))
      }
    #
    #
    #
    if(input$facet.by != ".")
      {
      #
      #
      #
      barFacet <- facet_grid(facets = . ~ type)
      }
    #
    # y-axis labels
    #
    yLabel <- labs(y = "Proportion")
    #
    # x-axis labels
    #
    xLabel <- labs(x = ifelse(input$group.by == "surveyArea", "Survey Area",
                         ifelse(input$group.by == "wealth", "Wealth Quintile",
                           ifelse(input$facet.by == "type", "Area Type", ""))))
    #
    #
    #
    indicator.plot <- basePlot + barPlot + barFill + theme_wsup + xLabel + yLabel
    #
    #
    #  
    if(input$facet.by != ".")
      {
      #
      # 
      #
      indicator.plot <- indicator.plot + barFacet
      }
    #
    #
    #
    if(input$group.by != ".")
      {
      #
      #
      #
      indicator.plot <- indicator.plot + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
      }
    #
    #
    #
    print(indicator.plot)
    }
  #
  #
  #
  if(input$varList %in% c("water9", "san8", "san20", "san22", "san24"))
    {
    #
    #
    #
    temp <- subset(sub.indicators(), select = grepl(input$varList, names(sub.indicators())))
    #
    #
    #
    zone <- NULL
    corporation <- NULL
    type <- NULL
    pQuintile <- NULL
    variables <- NULL
    #
    #
    #
    for(i in 1:ncol(temp))
	  {
	  #
	  #
	  #
	  zone <- c(zone, sub.indicators()$zone)
	  #
	  #
	  #
	  corporation <- c(corporation, as.character(sub.indicators()$corporation))
	  #
	  #
	  #
	  type <- c(type, sub.indicators()$type)
	  #
	  #
  	  #
	  pQuintile <- c(pQuintile, sub.indicators()$pQuintile)
	  #
	  #
	  #
	  variables <- c(variables, as.character(temp[ , i]))
	  }
    #
    #
    #
    paretoDF <- data.frame(zone, corporation, type, pQuintile, variables)
    #
    #
    #
    paretoDF$zone <- paste("Survey Area ", paretoDF$zone, sep = "")
    #
    #
    #
    paretoDF$corporation <- factor(paretoDF$corporation, levels = c("North City Corporation", "South City Corporation", "Outside"))
    #
    #
    #
    paretoDF$type <- ifelse(paretoDF$type == 1, "Low Income Area", "Citwyide")
    #
    #
    #
    paretoDF$pQuintile <- paste("Wealth Quintile ", paretoDF$pQuintile, sep = "")
    #
    #
    #
    basePlot <- ggplot(data = paretoDF[!is.na(paretoDF$variables), ], mapping = aes(x = variables))
    #
    #
    #
    barPlot <- geom_bar(stat = "count", position = "stack", fill = wsupColour, alpha = 0.6)
    #
    #
    #
    if(input$group.by == "surveyArea")
	  {
	  #
	  #
	  #
	  basePlot <- ggplot(data = paretoDF[!is.na(paretoDF$variables), ], mapping = aes(x = zone, fill = variables))
	  #
	  # 
	  #
	  barPlot <- geom_bar(stat = "count", position = "stack")
	  }
    #
    #
    #
    if(input$group.by == "corporation")
	  {
	  #
	  #
	  #
	  basePlot <- ggplot(data = paretoDF[!is.na(paretoDF$variables), ], mapping = aes(x = corporation, fill = variables))
	  #
	  # 
	  #
	  barPlot <- geom_bar(stat = "count", position = "stack")
	  }
    #
    #
    #
    if(input$group.by == "wealth")
	  {
	  #
	  #
	  #
	  basePlot <- ggplot(data = paretoDF[!is.na(paretoDF$variables), ], mapping = aes(x = pQuintile, fill = variables))
	  #
	  #
	  #
	  barPlot <- geom_bar(stat = "count", position = "stack")
	  }
    #
    #
    #
    if(input$group.by == "type")
      {
	  #
	  #
	  #
	  basePlot <- ggplot(data = paretoDF[!is.na(paretoDF$variables), ], mapping = aes(x = type, fill = variables))
	  #
	  #
	  #
	  barPlot <- geom_bar(stat = "count", position = "stack")
	  }
    #
    #
    #
    if(input$facet.by != ".")
	  {
	  #
	  #
	  #
	  barFacet <- facet_grid(facets = . ~ type)
	  }
    #
    #
    #
    barFill <- scale_fill_manual(name = "",
							     label = levels(paretoDF$variables),
							     values = brewer.pal(n = length(levels(paretoDF$variables)),
												     name = "Pastel1"))
	#
	#
	#
    xLabel <- labs(x = ifelse(input$group.by == "surveyArea", "Survey Area",
                          ifelse(input$group.by == "wealth", "Wealth Quintile",
                            ifelse(input$group.by == "type", "Area Type", ""))))
    #
    #
    #
    yLabel <- labs(y = "Frequency")
    #
    #
    #
    indicator.plot <- basePlot + barPlot + barFill + xLabel + yLabel + 
                      theme_wsup + theme(axis.text.x = element_text(angle = 45, 
                                                                    vjust = 1, 
                                                                    hjust = 1))
    #
    #
    #
    if(input$facet.by != ".")
	  {
	  #
	  #
	  #
	  indicator.plot <- indicator.plot + barFacet
	  }
    #
    #
    #
    print(indicator.plot)    
    }
  #
  #
  #
  if(input$varList %in% c("waterSource", "water10", "water11b", "san1", "san3", "san35a", "san28a"))
    {
    #
    #
    #
    temp <- sub.indicators()
    #
    #
    #
    temp$zone <- paste("Survey Area ", temp$zone, sep = "")
    #
    #
    #
    levels(temp$corporation) <- c("North City Corporation", "South City Corporation", "Outside")
    #
    #
    #
    temp$pQuintile <- paste("Wealth Quintile ", temp$pQuintile, sep = "")
    #
    #
    #
    temp$type <- ifelse(temp$type == 1, "Low Income Area", "Citywide")
    #
    #
    #
    temp <- temp[!is.na(temp[[input$varList]]), ]
    #
    #
    #
    temp$water10 <- factor(temp$water10, levels = c("Don't know", "<11 litres per day",
                                                    "11-20 litres per day", "21-40 litres per day",
                                                    "41-60 litres per day", "61-100 litres per day",
                                                    "101-150 litres per day", "151-200 litres per day",
                                                    "201-300 litres per day", ">301 litres per day"))
    #
    #
    #
    basePlot <- ggplot(data = temp, mapping = aes(x = get(input$varList)))
    #
    #
    #
    barPlot <- geom_bar(stat = "count", position = "stack", fill = wsupColour, alpha = 0.6)
    #
    #
    #
    if(input$group.by == "surveyArea")
      {
      #
      #
      #
      basePlot <- ggplot(data = temp, mapping = aes(x = zone, fill = get(input$varList)))
      #
      #
      #
      barPlot <- geom_bar(stat = "count", position = "fill", alpha = 0.6)
      }
    #
    #
    #
    if(input$group.by == "corporation")
      {
      #
      #
      #
      basePlot <- ggplot(data = temp, mapping = aes(x = corporation, fill = get(input$varList)))
      #
      #
      #
      barPlot <- geom_bar(stat = "count", position = "fill", alpha = 0.6)
      }
    #
    #
    #
    if(input$group.by == "wealth")
      {
      #
      #
      #
      basePlot <- ggplot(data = temp, mapping = aes(x = pQuintile, fill = get(input$varList)))
      #
      #
      #
      barPlot <- geom_bar(stat = "count", position = "fill", alpha = 0.6)
      }
    #
    #
    #
    barFill <- scale_fill_discrete(name = "")
    #
    #
    #
    yLabel <- labs(y = ifelse(input$group.by == ".", "Frequency", ""))
    #
    #
    #
    xLabel <- labs(x = ifelse(input$group.by == "surveyArea", "Survey Area",
                         ifelse(input$group.by == "wealth", "Wealth Quintile",
                           ifelse(input$group.by == "corporation", "City Corporation",
                             ifelse(input$facet.by == "type", "Area Type", "")))))
    #
    #
    #
    indicator.plot <- basePlot + barPlot + barFill + xLabel + yLabel + 
                      theme_wsup + theme(axis.text.x = element_text(angle = 45, 
                                                                    vjust = 1, 
                                                                    hjust = 1))
    #
    #
    #
    if(input$facet.by != ".")
      {
      #
      #
      #
      barFacet <- facet_grid(. ~ type)
      #
      #
      #
      indicator.plot <- indicator.plot + barFacet
      }
    #
    #
    #
    print(indicator.plot)
    }  
  #
  #
  #
  print(indicator.plot)
  #
  #
  #
  }, height = 320)                    
  #
  #
  #
  survey.area.map <- reactive({
    #
    #
    #
    if(input$country == "Bangladesh" & input$city == "Dhaka")
      {
      #
      #
      #
      inputFile <- input$shp.dhaka
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(dhaka.map) }
      #
      #
      #
      #names(survey.upload.dhaka())[names(survey.upload.dhaka()) == input$survey.area.id] <- "surveyArea"
      #
      #
      #
      return(survey.upload.dhaka())
      }
    #
    # If selected country is Ghana and selected city is Accra
    #
    if(input$country == "Ghana" & input$city == "Accra")
      {
      #
      #
      #
      inputFile <- input$shp.accra
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(accra.map) }
      #
      #
      #
      return(survey.upload.accra())
      }
    #
    # If selected country is Kenya and selected city is Nakuru
    #
    if(input$country == "Kenya" & input$city == "Nakuru")
      {
      #
      #
      #
      inputFile <- input$shp.nakuru
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(nakuru.map) }
      #
      #
      #
      return(survey.upload.nakuru())
      }
    #
    # If selected country is Madagascar and selected city is Antananarivo
    #
    if(input$country == "Madagascar" & input$city == "Antananarivo")
      {
      #
      #
      #
      inputFile <- input$shp.antananarivo
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(antananarivo.map) }
      #
      #
      #
      return(survey.upload.antananarivo())
      }
    #
    # If selected country is Mozambique and selected city is Maputo
    #
    if(input$country == "Mozambique" & input$city == "Maputo")
      {
      #
      #
      #
      inputFile <- input$shp.maputo
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(maputo.map) }
      #
      #
      #
      survey.upload.maputo()
      }
    #
    # If selected country is Zambia and selected city is Lusaka
    #
    if(input$country == "Zambia" & input$city == "Lusaka")
      {
      #
      #
      #
      inputFile <- input$shp.lusaka
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(lusaka.map) }
      #
      #
      #
      return(survey.upload.lusaka())
      }
  })
  #
  # Create map data for slum areas of current city and indicator
  #
  slum.map.data <- reactive({
    #
    #
    #
    temp <- subset(sub.data(), 
                   type == "Low Income Area" &
                   !strata %in% c(paste("Wealth Quintile ", 1:5, sep = ""), "Overall"))
    #
    #
    #
    if(input$varList %in% steer.indicators()$varList[steer.indicators()$varFunction == "proportion"])
      {
      #
      #
      #
      temp$estimate <- temp$estimate * 100
      }
    #
    #
    #
    if(input$country != "." & input$city != ".")
      {
      #
      #
      #
      merge(survey.area.map(), temp, by.x = "surveyArea", by.y = "strata")
      }
  })
  #
  # Create map data for city areas of current city and indicator
  #
  city.map.data <- reactive({
    #
    #
    #
    temp <- subset(sub.data(), 
                   type == "Citywide" &
                   !strata %in% c(paste("Wealth Quintile ", 1:5, sep = ""), "Overall"))
    #
    #
    #
    if(input$varList %in% steer.indicators()$varList[steer.indicators()$varFunction == "proportion"])
      {
      #
      #
      #
      temp$estimate <- temp$estimate * 100
      }
    #
    #
    #
    if(input$country != "." & input$city != ".")
      {
      #
      #
      #
      merge(survey.area.map(), temp, by.x = "surveyArea", by.y = "strata")
      }
  })
  #
  #
  #
  observe({   
    #
    #
    #
    yy <- c(slum.map.data()[[input$varList]], city.map.data()[[input$varList]])
    xx <- try(cut(yy, breaks = quantile(yy, probs = c(0.2, 0.4, 0.6, 0.8, 1))), silent = TRUE)
    #
    #
    #
    if(class(xx) == "try-error")
      #
      #
      #
      updateSelectInput(session = session,
                        inputId = "map.colour",
                        label = "Mapping method",
                        choices = list("Linear" = "linear",
                                       "Equal interval" = "interval"),
                        selected = "interval")
    #
    #
    #
    if(class(xx) != "try-error")
      #
      #
      #
      updateSelectInput(session = session,
                        inputId = "map.colour",
                        label = "Mapping method",
                        choices = list("Linear" = "linear",
                                       "Equal interval" = "interval",
                                       "Quantile" = "quantile"),
                        selected = "interval")
  })
  #
  # Map base layer
  #  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = get(input$mapbox.home),
        attribution = "Map by <a href = 'http://www.mapbox.com/'>Mapbox</a>"
      ) %>%
      setView(lng = 20, lat = 20, zoom = 3)
  })
  #
  # Get map centre and/or bounds of selected country
  #
  survey.country <- reactive({
    #
    #
    #
    if(input$country != ".") {
      #
      #
      #
      geocode(input$country, output = "more", messaging = FALSE)
    }
  })
  #
  # Get map centre and/or bounds of selected city
  #
  survey.city <- reactive({
    #
    #
    #
    if(input$city != ".") {
      #
      #
      #
      geocode(input$city, output = "more")
    }
  })
  #
  # Zoom in to selected country
  #
  observe({
    #
    #
    #
    leafletProxy("map") %>%
    #
    #
    #
    fitBounds(lng1 = survey.country()$east, lat1 = survey.country()$north,
  		      lng2 = survey.country()$west, lat2 = survey.country()$south)
  })    
  #
  # Zoom in to selected city
  #
  observe({
    #
    #
    #
    leafletProxy("map") %>%
    #
    #
    #
    fitBounds(lng1 = survey.city()$east, lat1 = survey.city()$north,
  		      lng2 = survey.city()$west, lat2 = survey.city()$south)
  }) 
  #
  # Clear maps when indicator set is changed
  #
  observeEvent(input$varSet != input$varSet, {
    #
    #
    #
    leafletProxy("map") %>%
    #
    #
    #
    clearShapes() %>%
    #
    #
    #
    clearControls() %>%
    #
    #
    #
    removeLayersControl()
  }) 
  #
  # Clear maps when indicator is set to none == "."
  #
  observeEvent(input$varList == ".", {
    #
    #
    #
    leafletProxy("map") %>%
    #
    #
    #
    clearShapes() %>%
    #
    #
    #
    clearControls() %>%
    #
    #
    #
    removeLayersControl()
  }) 
  #
  # Clear maps when control panel is reset
  #
  observeEvent(input$refresh.chart.settings, {
    #
    #
    #
    leafletProxy("map") %>%
    #
    #
    #
    clearShapes() %>%
    #
    #
    #
    clearControls() %>%
    #
    #
    #
    removeLayersControl() %>%
    #
    #
    #
    setView(lng = 20, lat = 20, zoom = 3)
  }) 
  #
  # Clear maps when specific set of indicators are selected
  #
  observeEvent(input$varList %in% c("waterSource", "water9", "water10", 
                                    "water11b", "san1", "san3", "san8", "san20", 
                                    "san22", "san24", "san35a", "san28a"), {
    #
    #
    #
    leafletProxy("map") %>%
    #
    #
    #
    clearShapes() %>%
    #
    #
    #
    clearControls() %>%
    #
    #
    #
    removeLayersControl()
  }) 
  #
  # Plot indicator maps
  #   
  observe({
    #
    #
    #
    if(input$varList != "." & !input$varList %in% c("waterSource", "water9", "water10", 
                                                    "water11b", "san1", "san3", "san8", "san20", 
                                                    "san22", "san24", "san35a", "san28a"))
      {
	  #
	  # 
 	  #
	  if(input$map.colour == "linear")
	    {
	    #
	    #
	    #
	    values <- c(0, max(c(slum.map.data()[["estimate"]], city.map.data()[["estimate"]])))      
	    #
	    #
	    #
	    pal <- colorNumeric(palette = input$map.palette,
		  				    domain = values)
	    }
	  #
	  #
	  #
	  if(input$map.colour == "interval")
	    {
	    #
	    #
	    #
	    values <- c(0, max(c(slum.map.data()[["estimate"]], city.map.data()[["estimate"]])))
	    #
	    #
	    #
	    pal <- colorBin(palette = input$map.palette, 
					    domain = values,
					    pretty = TRUE,
					    bins = ifelse(is.null(input$map.bins), 5, input$map.bins))
	    }
	  #
	  #
	  #
	  if(input$map.colour == "quantile")
	    {
	    #
	    #
	    #
	    pal <- colorQuantile(palette = input$map.palette,
		   				     domain = c(slum.map.data()[["estimate"]], city.map.data()[["estimate"]]),
						     n = ifelse(is.null(input$map.quantiles), 5, input$map.quantiles))
	    #
	    #
	    #
	    values <- c(slum.map.data()[["estimate"]], city.map.data()[["estimate"]])
	    }
	  #
	  #
	  #  
	  slum.labels <- paste(slum.map.data()$surveyArea, ": ", round(slum.map.data()[["estimate"]], digits = 1), "%", sep = "")
	  #
	  #
	  #
	  city.labels <- paste(city.map.data()$surveyArea, ": ", round(city.map.data()[["estimate"]], digits = 1), "%", sep = "")
	  #
	  #
	  #
	  if(input$varList %in% steer.indicators()$varList[steer.indicators()$varFunction != "proportion"])
	    {
	    #
	    #
        #  
	    slum.labels <- paste(slum.map.data()$surveyArea, ": ", round(slum.map.data()[["estimate"]], digits = 1), sep = "")
	    #
	    #
	    #
	    city.labels <- paste(city.map.data()$surveyArea, ": ", round(city.map.data()[["estimate"]], digits = 1), sep = "")
	    }
	  #
	  #
	  #
	  leafletProxy("map") %>%
	  #
	  #
	  #
	  clearShapes() %>%
	  #
	  #
      #
      clearControls() %>%
	  #
	  # Slum polygon
 	  #
	  addPolygons(
	    data = slum.map.data(),
	    fillColor = pal(slum.map.data()[["estimate"]]),
	    weight = 2,
	    opacity = 1,
	    color = "white",
	    dashArray = "",
	    fillOpacity = 0.7,
	    highlight = highlightOptions(
		  weight = 5,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0.7,
		  bringToFront = TRUE),
	    label = slum.labels,
	    labelOptions = labelOptions(
		  style = list("font-weight" = "normal", padding = "3px 8px"),
		  textsize = "12px",
		  direction = "auto"),
	    group = "Low income area") %>%
	  #
	  # Citywide polygon
	  #
	  addPolygons(
	    data = city.map.data(),
	    fillColor = pal(city.map.data()[["estimate"]]),
	    weight = 2,
	    opacity = 1,
	    color = "white",
	    dashArray = "",
	    fillOpacity = 0.7,
	    highlight = highlightOptions(
		  weight = 5,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0.7,
		  bringToFront = TRUE),
	    label = city.labels,
	    labelOptions = labelOptions(
		  style = list("font-weight" = "normal", padding = "3px 8px"),
		  textsize = "12px",
		  direction = "auto"),
	    group = "Citywide") %>%
	  #
	  #
	  #
	  addLegend(pal = pal, values = values, opacity = 0.7,
		position = "bottomright", 
		labFormat = ifelse(input$map.colour == "quantile" & input$varList %in% steer.indicators()$varList[steer.indicators()$varFunction == "proportion"], legend.format(digits = 1, between = " to ", suffix = "%"),
		              ifelse(input$map.colour == "quantile" & input$varList %in% steer.indicators()$varList[steer.indicators()$varFunction != "proportion"], legend.format(digits = 1, between = " to "),
		                ifelse(input$varList %in% steer.indicators()$varList[steer.indicators()$varFunction != "proportion"], labelFormat(digits = 1, between = " to "), labelFormat(digits = 1, between = " to ", suffix = "%")))),
		layerId = "legend") %>%
	  #
	  #
	  #
	  addLayersControl(
		baseGroups = c("Low income area", "Citywide"),
		position = "topleft",
		options = layersControlOptions(collapsed = FALSE, autoZIndex = TRUE)) #%>%
	  #
	  #
	  #
    }
  })
  
  
################################################################################
#
# Sample size function
#
################################################################################
  #
  #
  #
  sample.df <- reactive({
    #
    #
    #
    inputFile <- input$file2
    #
    #
    #
    if(is.null(inputFile))
      {
      #
      #
      #
      return(NULL)
      }
    #
    #
    #
    read.csv(file = inputFile$datapath, header = TRUE, sep = ",")
  })    

  #
  #
  #
  observe({
      #
      #
      #
      updateSelectInput(session = session,
                        inputId = "variable",
                        label = "Select variable name of indicator to test",
                        choices = names(sample.df()))
      #
      #
      #
      updateSelectInput(session = session,
                        inputId = "cluster",
                        label = "Select variable name of survey cluster",
                        choices = names(sample.df()))
  })
  #
  #
  #
  observeEvent(input$calculate1, {
	  #
	  #
	  #
	  z.value <- ifelse(input$z.ci == "1.96", "95% CI",
			   	   ifelse(input$z.ci == "1.75", "92% CI",
				     ifelse(input$z.ci == "1.645", "90% CI", "96% CI")))
	  #
	  # Calculate sample size
	  #
	  sample.size1 <- (as.numeric(input$z.ci) ^ 2) * (((input$proportion / 100) * (1 - (input$proportion / 100))) / ((input$precision / 100) ^ 2))
	  #    
	  # Compose data frame
	  #
	  sample.parameters <- data.frame(Parameters = c("z-value", 
													 "Prevalence",
													 "Precision",
													 "Sample size"),
									  Value = as.character(c(paste(input$z.ci, " (", z.value, ")", sep = "") , 
										 					 paste(input$proportion, "%", sep = ""),
															 paste(input$precision, "%", sep = ""),
															 ceiling(sample.size1))), 
									  stringsAsFactors = FALSE)
      #
      #
      #
      output$sample.header <- renderText({
        #
        #
        #
        "Sample size parameters and estimate (SRS)"
      })
	  #
	  #
	  #
	  output$sample <- renderTable({
	    #
	    #
        #
		sample.parameters
	  })
  })
  #
  #
  #
  observeEvent(input$reset1, {
      #
      #
      #
      output$sample.header <- renderText({NULL})
      #
      #
      #
      output$sample <- renderTable({NULL})
      #
      #
      #
      shinyjs::reset("sample-size")
  })
  #
  #
  #
  observeEvent(input$surveyType == "cluster", {
      #
      #
      #
      output$sample.header <- renderText({NULL})
      #
      #
      #
      output$sample <- renderTable({NULL})
  })
  #
  #
  #
  observeEvent(input$calculate2, {
      #
      # Assign deff
      #
      design.effect <- 5
	  #
	  # Calculate deff
	  #
	  if(!is.null(input$file2))
	    {
	    #
	    #
	    #
	    icc <- deff(y = sample.df()[[input$variable]], cluster = sample.df()[[input$cluster]])[["rho"]]
	    #
	    #
	    #
	    design.effect <- 1 + (input$cluster.size - 1) * icc
	    }
	  #
	  #
	  #
	  z.value <- ifelse(input$z.ci == "1.96", "95% CI",
			   	   ifelse(input$z.ci == "1.75", "92% CI",
				     ifelse(input$z.ci == "1.645", "90% CI", "96% CI")))
	  #
	  # Calculate sample size
	  #
	  sample.size2 <- design.effect * (as.numeric(input$z.ci.cluster) ^ 2) * (((input$proportion.cluster / 100) * (1 - (input$proportion.cluster / 100))) / ((input$precision.cluster / 100) ^ 2))
	  #    
	  # Compose data frame
	  #
	  deff.parameters <- data.frame(Parameters = c("z-value", 
												   "Prevalence",
												   "Precision",
												   "Cluster size",
												   "ICC",
												   "Design effect of planned survey",
												   "Sample size"),
									Value = as.character(c(paste(input$z.ci.cluster, " (", z.value, ")", sep = "") , 
										 				   paste(input$proportion.cluster, "%", sep = ""),
														   paste(input$precision.cluster, "%", sep = ""),
									                       paste(input$cluster.size, "samples per cluster", sep = " "),
									                       ifelse(is.null(input$file2), "No data", round(icc, digits = 4)), 
								                           ifelse(is.null(input$file2), paste(design.effect, "(assumed)", sep = " "), paste(round(design.effect, digits = 4), "(based on data)", sep = " ")),
								                           ceiling(sample.size2))),
                                    stringsAsFactors = FALSE)      
      #
      #
      #
      output$deff.header <- renderText({
        #
        #
        #
        "Sample size parameters and estimate (Cluster Sample)"
      })
	  #
	  #
	  #
	  output$deff <- renderTable({
	    #
	    #
        #
		deff.parameters
	  })
  })
  #
  #
  #
  observeEvent(input$reset2, {
      #
      #
      #
      output$deff.header <- renderText({NULL})
      #
      #
      #
      output$deff <- renderTable({NULL})
      #
      #
      #
      shinyjs::reset("sample-size")
  })
  #
  #
  #
  observeEvent(input$reset.colours, {
      #
      #
      #
      shinyjs::reset("colours.panel")
  })
  #
  #
  #
  observeEvent(input$reset.maps, {
      #
      #
      #
      shinyjs::reset("maps.panel")
  })

    
################################################################################
#
# Spatial sampling
#
################################################################################
  #
  #
  #
  output$map.sampling <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Esri.NatGeoWorldMap) %>%      
      setView(lng = 20, lat = 20, zoom = 3)
  })


################################################################################
#
# Read shapefile
#
################################################################################
  #
  #
  #
  city.map <- reactive({
    #
    #
    #
    inputFile <- input$shp1
    #
    #
    #
    if(is.null(inputFile)) { return(NULL) }
    #
    #
    #  
    infiles <- inputFile$datapath
    #
    #
    #
    dir <- unique(dirname(infiles))
    #
    #
    #
    outfiles <- file.path(dir, inputFile$name)
    #
    #
    #
    purrr:::walk2(infiles, outfiles, ~file.rename(.x, .y))
    #
    #
    #
    x <- try(readOGR(dir, strsplit(inputFile$name[1], "\\.")[[1]][1]), TRUE)
    #
    #
    #
    if(class(x) == "try-error") { return(NULL) } 
    #
    #
    #
    else
    #
    # Transform shapefiles into WGS84 longlat
    #
    x <- spTransform(x = x, CRSobj = CRS(long.lat.crs))
  })
  #
  #
  #
  slum.map <- reactive({
    #
    #
    #
    inputFile <- input$shp2
    #
    #
    #
    if(is.null(inputFile)) { return(NULL) }
    #
    #
    #  
    infiles <- inputFile$datapath
    #
    #
    #
    dir <- unique(dirname(infiles))
    #
    #
    #
    outfiles <- file.path(dir, inputFile$name)
    #
    #
    #
    purrr:::walk2(infiles, outfiles, ~file.rename(.x, .y))
    #
    #
    #
    x <- try(readOGR(dir, strsplit(inputFile$name[1], "\\.")[[1]][1]), TRUE)
    #
    #
    #
    if(class(x) == "try-error") NULL 
    #
    #
    #
    else
    #
    # Transform shapefiles into WGS84 longlat
    #
    x <- spTransform(x = x, CRSobj = CRS(long.lat.crs))
  })

  #
  #
  #
  observeEvent(input$mapDraw1, {
      #
      #
      #
      leafletProxy("map.sampling") %>%
      #
      #
      #
      clearTiles() %>%
      #
      #
      #
      clearShapes() %>%
      #
      #
      #
      clearMarkers() %>%
      #
      #
      #
      addTiles(
        urlTemplate = mapbox.satellite,
        attribution = "Map by <a href='https://www.mapbox.com'>Mapbox</a>"
      ) %>%
      #
      #
      #
      fitBounds(lng1 = bbox(city.map())[1,1], 
                lat1 = bbox(city.map())[2,1], 
                lng2 = bbox(city.map())[1,2], 
                lat2 = bbox(city.map())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = city.map(),
	    weight = 2,
	    opacity = 1,
	    color = "yellow",
	    dashArray = "",
	    fillOpacity = 0,
	    highlight = highlightOptions(
		  weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0,
		  bringToFront = FALSE),
		group = "Survey Areas") %>%
        #
        # Add layer control
        #
        addLayersControl(
          baseGroups = c("Survey Areas"),
          position = "topleft",
          options = layersControlOptions(collapsed = FALSE)) %>%
        #
        # Keep baselayers at base of map
        #
        htmlwidgets::onRender("
          function(el, x) {
            this.on('baselayerchange', function(e) {
              e.layer.bringToBack();
            })
          }
        ")          		      
  })    
  #
  #
  #
  observeEvent(input$mapDraw2, {
      #
      #
      #
      leafletProxy("map.sampling") %>%
      #
      #
      #
      clearTiles() %>%
      #
      #
      #
      clearShapes() %>%
      #
      #
      #
      clearMarkers() %>%
      #
      #
      #
      addTiles(
        urlTemplate = mapbox.satellite,
        attribution = "Map by <a href='https://www.mapbox.com'>Mapbox</a>"
      ) %>%
      #
      #
      #
      fitBounds(lng1 = bbox(slum.map())[1,1], 
                lat1 = bbox(slum.map())[2,1], 
                lng2 = bbox(slum.map())[1,2], 
                lat2 = bbox(slum.map())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = slum.map(),
	    weight = 2,
	    opacity = 1,
	    color = "yellow",
	    dashArray = "",
	    fillOpacity = 0,
	    highlight = highlightOptions(
		  weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0,
		  bringToFront = FALSE),
		group = "Slum Areas") %>%
        #
        # Add layer control
        #
        addLayersControl(
          baseGroups = c("Low Income Areas"),
          position = "topleft",
          options = layersControlOptions(collapsed = FALSE)) %>%
        #
        # Keep baselayers at base of map
        #
        htmlwidgets::onRender("
          function(el, x) {
            this.on('baselayerchange', function(e) {
              e.layer.bringToBack();
            })
          }
        ")		      
  })
  #
  #
  #
  observeEvent(input$shp1, {
    #
    #
    #
    updateSelectInput(session = session,
                      inputId = "var.city.area",
                      label = "Select map data identifier for city survey areas",
                      choices = names(city.map()))
  })
  #
  #
  #
  observeEvent(input$shp2, {
    #
    #
    #
    updateSelectInput(session = session,
                      inputId = "var.slum.area1",
                      label = "Select map data identifier for slum survey areas",
                      choices = names(slum.map()))
  })
  #
  #
  #
  observeEvent(input$list1, {
    #
    #
    #
    updateSelectInput(session = session,
                      inputId = "var.slum.area2",
                      label = "Select map data identifier for slum survey areas",
                      choices = names(sample.list.df()))
  })
  #
  #
  #
  observeEvent(input$var.city.area, {
    #
    #
    #
    updateSelectInput(session = session,
                      inputId = "city.area.name",
                      label = "Select city area",
                      choices = levels(city.map()[[input$var.city.area]]))
  })
  #
  #
  #
  observeEvent(input$var.slum.area1, {
    #
    #
    #
    updateSelectInput(session = session,
                      inputId = "slum.area.name1",
                      label = "Select low income area",
                      choices = levels(slum.map()[[input$var.slum.area1]]))
  })
  #
  #
  #
  observeEvent(input$var.slum.area2, {
    #
    #
    #
    updateSelectInput(session = session,
                      inputId = "slum.area.name2",
                      label = "Select low income area",
                      choices = levels(sample.list.df()[[input$var.slum.area2]]))
  })
  #
  #
  #
  output$map.draw.control1 <- renderUI({
    #
    #
    #
    if(!is.null(input$shp1))
      {
      #
      #
      #
      actionButton(inputId = "mapDraw1",
                   label = "Map",
                   class = "btn-primary",
                   icon = icon(name = "map", class = "fa-lg"))
      }
  })
  #
  #
  #
  output$map.draw.control2 <- renderUI({
    #
    #
    #
    if(!is.null(input$shp2))
      {
      #
      #
      #
      actionButton(inputId = "mapDraw2",
                   label = "Map",
                   class = "btn-primary",                   
                   icon = icon(name = "map", class = "fa-lg"))
      }
  })
  #
  #
  #
  xGrid <- eventReactive(input$sample.city, {
	#
	# Subset to current survey area
	#
	temp <- subset(city.map(), get(input$var.city.area) == input$city.area.name)
	#
	# Grid current area
	#
	repeat
	  {
	  #
	  # Spatial sample
	  #
	  xSP <- spsample(x = temp, 
					  n = input$n.psu.citywide, 
					  type = "regular")
	  #
	  # Check if there are enough grids
	  #
	  if(length(xSP) == input$n.psu.citywide) break
	  }  
	  #
	  # Create identifiers
	  #
	  areaID    <- rep(input$city.area.name, length(xSP))
	  quadratID <- 1:length(xSP)
	  longitude <- xSP@coords[ , 1] 
	  latitude  <- xSP@coords[ , 2]
	  #
	  #
	  #
	  xGrid <- as(as(xSP, "SpatialPixels"), "SpatialPolygons")
	  #
	  #
	  #
	  xGrid <- SpatialPolygonsDataFrame(Sr = xGrid,
										data = data.frame(areaID, quadratID, longitude, latitude),
										match.ID = FALSE)
  })				
  #
  # 
  #
  output$city.grid.table <- DT::renderDataTable(DT::datatable({
	#
	#
    #
    xGrid()@data
  }))
  #
  #
  #
  output$city.download1 <- downloadHandler(
    #
    #
    #
    filename = function() {
      #
      #
      #
      paste("cityList", input$city.area.name, ".csv", sep= "")
    },
    #
    #
    #
    content = function(file) {
      #
      #
      #
      write.csv(xGrid()@data, file)
    }
  )
  #
  #
  #
  output$download.city <- renderUI({
    #
    #
    #
    if(input$sample.city)
      #
      #
      #
      downloadButton(outputId = "city.download1",
                     label = "Download",
                     class = "btn-primary",
                     icon = icon(name = "download", class = "fa-lg"))
  })
  #
  #
  #
  observeEvent(xGrid(), {
       #
       #
       #
       leafletProxy("map.sampling") %>%
       #
       #
       #
       clearShapes() %>%
       #
       #
       #
       clearMarkers() %>%
       #
       #
       #
       clearControls() %>%
       #
       #
       #
      fitBounds(lng1 = bbox(xGrid())[1,1], 
                lat1 = bbox(xGrid())[2,1], 
                lng2 = bbox(xGrid())[1,2], 
                lat2 = bbox(xGrid())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = city.map(),
	    weight = 2,
	    opacity = 1,
	    color = "yellow",
	    dashArray = "",
	    fillOpacity = 0,
	    highlight = highlightOptions(
		  weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0,
		  bringToFront = FALSE),
		group = "Survey Areas") %>%
       #
       # Add survey area polygon layer
       #
	   addPolygons(
	     data = xGrid(),
	     weight = 3,
	     opacity = 1,
	     color = "blue",
	     dashArray = "",
	     fillOpacity = 0,
	     highlight = highlightOptions(
		   weight = 4,
		   color = "#666",
		   dashArray = "",
		   fillOpacity = 0,
		   bringToFront = TRUE),
		  group = paste(input$city.area.name, "grids", sep = " ")) %>%
		#
		#
		#
		addCircleMarkers(
		  data = xGrid(),
		  lng =  coordinates(xGrid())[,1],
		  lat = coordinates(xGrid())[,2],
		  radius = 5,
		  fill = TRUE,
		  fillColor = "red",
		  fillOpacity = 0.8,
		  color = "red",
		  group = paste(input$city.area.name, "sampling points", sep = " ")) %>%
        #
        # Add layer control
        #
        addLayersControl(
          baseGroups = c("Survey Areas"),
          overlayGroups = c(paste(input$city.area.name, "grids", sep = " "), paste(input$city.area.name, "sampling points", sep = " ")),
          position = "topleft",
          options = layersControlOptions(collapsed = FALSE)) %>%
        #
        # Keep baselayers at base of map
        #
        htmlwidgets::onRender("
          function(el, x) {
            this.on('baselayerchange', function(e) {
              e.layer.bringToBack();
            })
          }
        ")          		      
  })         
  #
  #
  #
  sGrid <- eventReactive(input$sample.slum1, {
	#
	# Subset to current survey area
	#
	temp <- subset(slum.map(), get(input$var.slum.area1) == input$slum.area.name1)
	#
	# Grid current area
	#
	repeat
	  {
	  #
	  # Spatial sample
	  #
	  xSP <- spsample(x = temp, 
					  n = input$n.psu.slum, 
					  type = "regular")
	  #
	  # Check if there are enough grids
	  #
	  if(length(xSP) == input$n.psu.citywide) break
	  }  
	  #
	  # Create identifiers
	  #
	  areaID    <- rep(input$slum.area.name1, length(xSP))
	  quadratID <- 1:length(xSP)
	  longitude <- xSP@coords[ , 1] 
	  latitude  <- xSP@coords[ , 2]
	  #
	  #
	  #
	  sGrid <- as(as(xSP, "SpatialPixels"), "SpatialPolygons")
	  #
	  #
	  #
	  sGrid <- SpatialPolygonsDataFrame(Sr = sGrid,
										data = data.frame(areaID, quadratID, longitude, latitude),
										match.ID = FALSE)
  })				
  #
  # 
  #
  output$slum.grid.table <- DT::renderDataTable(DT::datatable({
	#
	#
    #
    sGrid()@data
  }))
  #
  #
  #
  output$slum.download1 <- downloadHandler(
    #
    #
    #
    filename = function() {
      #
      #
      #
      paste("liaList", input$slum.area.name1, ".csv", sep= "")
    },
    #
    #
    #
    content = function(file) {
      #
      #
      #
      write.csv(sGrid()@data, file)
    }
  )
  #
  #
  #
  output$download.slum1 <- renderUI({
    #
    #
    #
    if(input$sample.slum1)
      #
      #
      #
      downloadButton(outputId = "slum.download1",
                     label = "Download",
                     class = "btn-primary",
                     icon = icon(name = "download", class = "fa-lg"))
  })
  #
  #
  #
  observeEvent(sGrid(), {
       #
       #
       #
       leafletProxy("map.sampling") %>%
       #
       #
       #
       clearShapes() %>%
       #
       #
       #
       clearMarkers() %>%
       #
       #
       #
       clearControls() %>%
       #
       #
       #
       #setView(lng = mean(coordinates(sGrid())[,1]), 
       #        lat = mean(coordinates(sGrid())[,2]), 
       #        zoom = 13) %>%
      fitBounds(lng1 = bbox(sGrid())[1,1], 
                lat1 = bbox(sGrid())[2,1], 
                lng2 = bbox(sGrid())[1,2], 
                lat2 = bbox(sGrid())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = slum.map(),
	    weight = 2,
	    opacity = 1,
	    color = "yellow",
	    dashArray = "",
	    fillOpacity = 0,
	    highlight = highlightOptions(
		  weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0,
		  bringToFront = FALSE),
		group = "Survey Areas") %>%
       #
       # Add survey area polygon layer
       #
	   addPolygons(
	     data = sGrid(),
	     weight = 3,
	     opacity = 1,
	     color = "blue",
	     dashArray = "",
	     fillOpacity = 0,
	     highlight = highlightOptions(
		   weight = 4,
		   color = "#666",
		   dashArray = "",
		   fillOpacity = 0,
		   bringToFront = TRUE),
		  group = paste(input$slum.area.name1, "grids", sep = " ")) %>%
		#
		# Add centroids
		#
		addCircleMarkers(
		  data = sGrid(),
		  lng =  coordinates(sGrid())[,1],
		  lat = coordinates(sGrid())[,2],
		  radius = 5,
		  fill = TRUE,
		  fillColor = "red",
		  fillOpacity = 0.8,
		  color = "red",
		  group = paste(input$slum.area.name1, "sampling points", sep = " ")) %>%
        #
        # Add layer control
        #
        addLayersControl(
          baseGroups = c("Survey Areas"),
          overlayGroups = c(paste(input$slum.area.name1, "grids", sep = " "), paste(input$slum.area.name1, "sampling points", sep = " ")),
          position = "topleft",
          options = layersControlOptions(collapsed = FALSE)) %>%		      
        #
        # Keep baselayers at base of map
        #
        htmlwidgets::onRender("
          function(el, x) {
            this.on('baselayerchange', function(e) {
              e.layer.bringToBack();
            })
          }
        ")
  })         
  #
  #
  #
  sample.list.df <- reactive({
    #
    #
    #
    inputFile <- input$list1
    #
    #
    #
    if(is.null(inputFile))
      {
      #
      #
      #
      return(NULL)
      }
    #
    #
    #
    read.csv(file = inputFile$datapath, header = TRUE, sep = ",")
  })    
  #
  #
  #
  sample.slum.list <- eventReactive(input$sample.slum2, {
	  #
	  #
	  #
      temp <- subset(sample.list.df(), get(input$var.slum.area2) == input$slum.area.name2)
	  #
	  #
	  #
	  stepInterval <- floor(nrow(temp) / input$n.psu.slum)
      #
	  #
	  #
	  startPoint <- sample(x = 1:input$n.psu.slum, size = 1, replace = FALSE)
	  #
	  #
	  #
	  selectList <- seq(from = startPoint, to = nrow(temp), by = stepInterval)
	  #
	  #
	  #
	  sample.slum.list <- temp[selectList, ]
  })
  #
  #
  #
  output$sample.slum.table <- DT::renderDataTable(DT::datatable({
	#
	#
	#
	sample.slum.list()
  }))
  #
  #
  #
  output$slum.download2 <- downloadHandler(
    #
    #
    #
    filename = function() {
      #
      #
      #
      paste("liaList", input$slum.area.name2, ".csv", sep= "")
    },
    #
    #
    #
    content = function(file) {
      #
      #
      #
      write.csv(sample.slum.list(), file)
    }
  )
  #
  #
  #
  output$download.slum2 <- renderUI({
    #
    #
    #
    if(input$sample.slum2)
      #
      #
      #
      downloadButton(outputId = "slum.download2",
                     label = "Download",
                     class = "btn-primary",
                     icon = icon(name = "download", class = "fa-lg"))
  })
  #
  # Subset steerIndicators to current city and country
  #
  steer.corr <- eventReactive(input$country.corr != ".", {
    #
    #
    #
    steerIndicators[steerIndicators[[input$country.corr]] == 1, ]
  })
  #
  #
  #
  vars.corr <- reactive({
    #
    # Create indicator choices for dropdown
    #
    temp <- as.character(steer.corr()$varList)
    names(temp) <- steer.corr()$varShort
    #
    #
    #
    return(temp)
  })
  #
  #
  #
  output$x.corr <- renderUI({
    #
    #
    #
    selectInput(inputId = "x.corr",
                label = "Independent variable",
                choices = c(Select = "", names(stat.dataset())),
                multiple = FALSE,
                selected = "")
    })
  #
  #
  #
  output$y.corr <- renderUI({
    #
    #
    #
    selectInput(inputId = "y.corr",
                label = "Dependent variable",
                choices = c(Select = "", names(stat.dataset())),
                multiple = FALSE,
                selected = "")
  })
  #
  #
  #
  output$x.var <- renderUI({
    #
    #
    #
    selectInput(inputId = "x.var",
                label = "Independent variable",
                choices = c(Select = "", names(stat.dataset())),
                multiple = FALSE,
                selected = "")
    })
  #
  #
  #
  output$y.var <- renderUI({
    #
    #
    #
    selectInput(inputId = "y.var",
                label = "Dependent variable",
                choices = c(Select = "", names(stat.dataset())),
                multiple = FALSE,
                selected = "")
  })
  #
  # Read uploaded data
  #
  temp <- reactive({
    #
    # Use pre-loaded data if no dataset is uploaded
    #
    inputFile <- input$stat.test.data
    #
    #
    #
    if(is.null(inputFile))
      {
      #
      #
      #
      return(NULL)
      }
    #
    #
    #
    else
      {
      #
      # Read dataset file
      #
      read.csv(file = inputFile$datapath, header = TRUE, sep = ",")
      }
  })
  #
  #
  #
  observeEvent(input$stat.test.data, {
    #
    #
    #
    updateSelectInput(session = session,
                      inputId = "country.corr",
                      label = "Subset data to selected city",
                      choices = c("Select" = ".", 
                                  "All" = "all", 
                                  unique(as.character(temp()$country))))
  })
  #
  #
  #
  stat.dataset <- reactive({
    #
    #
    #
    if(input$country.corr != "all" & input$country.corr != ".")
      {
      #
      #
      #
      subset(temp(), country == input$country.corr)
      }
    #
    #
    #
    else
      {
      #
      #
      #
      temp()
      }
  })
  #
  #
  #
  output$corr.results <- renderTable({
    #
    #
    #
    req(input$x.corr, input$y.corr, input$z.corr)
	  {
	  #
	  #
	  #
	  temp <- cor.test(x = stat.dataset()[[input$x.corr]], 
	                   y = stat.dataset()[[input$y.corr]], 
	                   method = input$z.corr)
	  }
    #
    #
    #
    if(input$z.corr == "pearson")
	  {
	  #
	  #
	  #
	  ci <- paste(round(temp$conf.int[1], digits = 4), " to ", round(temp$conf.int[2], digits = 4), sep = "")
	  #
 	  #
	  #
	  results.vector <- c(round(temp$statistic, digits = 4), 
	  					  round(temp$parameter, digits = 4), 
						  round(temp$p.value, digits = 4), 
						  round(temp$estimate, digits = 4), 
						  ci)
	  results.name <- c("Test statistic", 
	                    "Degrees of freedom (df)", 
	                    "p-value", 
	                    "Correlation coefficient", 
	                    "95% CI")
	  }
    #
    #
    #
    if(input$z.corr == "kendall")
	  {
	  #
	  #
	  #
	  results.vector <- c(round(temp$statistic, digits = 4), 
						  round(temp$p.value, digits = 4), 
						  round(temp$estimate, digits = 4))
	  results.name <- c("Test statistic", "p-value", "Correlation coefficient")
	  }    
  #
  #
  #
  results.table <- data.frame(results.name, results.vector)
  #
  #
  #
  names(results.table) <- c("Parameters", "Values")
  #
  #
  #
  results.table
  })
  #
  #
  #
  output$corr.results.header <- renderText({
    #
    #
    #
    req(input$x.corr, input$y.corr, input$z.corr)
      {
      #
      #
      #
      temp <- cor.test(x = stat.dataset()[[input$x.corr]], 
                       y = stat.dataset()[[input$y.corr]], 
                       method = input$z.corr)
      }
    #
    #
    #
    temp$method
  })
  #
  #
  #
  output$corr.results.description <- renderText({
    #
    #
    #
    req(input$x.corr, input$y.corr, input$z.corr)
      {
      #
      #
      #
      temp <- cor.test(x = stat.dataset()[[input$x.corr]], 
                       y = stat.dataset()[[input$y.corr]], 
                       method = input$z.corr)
      }
    #
    #
    #
    paste("Correlation between ", input$x.corr, " and ", input$y.corr, sep = "")
  })
  #
  #
  #
  output$var.results.t <- renderTable({
    #
    #
    #
    req(input$x.var, input$y.var, input$z.var)
      {
      #
      #
      #
      if(input$z.var == "t.test")
        {
        #
        #
        #
        diff.test <- ifelse(bartlett.test(x = stat.dataset()[[input$x.var]], g = stat.dataset()[[input$y.var]])$p.value < 0.05, TRUE, FALSE)
        #
        #
        #
        temp <- t.test(x = stat.dataset()[[input$x.var]], 
                       y = stat.dataset()[[input$y.var]], 
                       var.equal = diff.test)
        #
        #
        #
        results.vector <- c(round(temp$statistic, digits = 4),
                            round(temp$parameter, digits = 4),
                            round(temp$p.value, digits = 4))
        results.name <- c("t statistic", "Degrees of freedom (df)", "p-value")
        #
        #
        #
        results.table <- data.frame(results.name, results.vector)
        #
        #
        #
        names(results.table) <- c("Parameters", "Values")
        #
        #
        #
        results.table
        }
      }
  })
  #
  #
  #
  output$var.results.wilcox <- renderTable({
    #
    #
    #
    req(input$x.var, input$y.var, input$z.var)
      {    
      #
      #
      #
      if(input$z.var == "wilcox")
        {
        #
        #
        #
        temp <- wilcox.test(x = stat.dataset()[[input$x.var]], 
                            y = stat.dataset()[[input$y.var]], 
                            conf.int = TRUE, 
                            exact = FALSE)
        #
        #
        #
        results.vector <- c(round(temp$statistic, digits = 4),
                            round(temp$p.value, digits = 4))
        results.name <- c("W statistic", "p-value")
        #
        #
        #
        results.table <- data.frame(results.name, results.vector)
        #
        #
        #
        names(results.table) <- c("Parameters", "Values")
        #
        #
        #
        results.table
        }
      }
  })  
  #
  #
  #
  output$var.results.kruskal <- renderTable({
    #
    #
    #
    req(input$x.var, input$y.var, input$z.var)
      {    
      #
      #
      #
      if(input$z.var == "kruskal")
        {
        #
        #
        #
        temp <- kruskal.test(x = stat.dataset()[[input$x.var]], g = stat.dataset()[[input$y.var]])
        #
        #
        #
        #
        #
        #
        results.vector <- c(round(temp$statistic, digits = 4),
                            round(temp$parameter, digits = 4),
                            round(temp$p.value, digits = 4))
        results.name <- c("Kruskal-Wallis chi-squared statistic", "Degrees of freedom", "p-value")
        #
        #
        #
        results.table <- data.frame(results.name, results.vector)
        #
        #
        #
        names(results.table) <- c("Parameters", "Values")
        #
        #
        #
        results.table
        }
      }
  })
  #
  #
  #
  output$var.results.t.header <- renderText({
    #
    #
    #
    req(input$x.var, input$y.var, input$z.var)
      {
      #
      #
      #
      if(input$z.var == "t.test")
        {
        #
        #
        #    
        diff.test <- ifelse(bartlett.test(x = stat.dataset()[[input$x.var]], g = stat.dataset()[[input$y.var]])$p.value < 0.05, TRUE, FALSE)
        #
        #
        #
        t.test(x = stat.dataset()[[input$x.var]], y = stat.dataset()[[input$y.var]], var.equal = diff.test)$method
        }
      }
  })
  #
  #
  #
  output$var.results.wilcox.header <- renderText({
    #
    #
    #
    req(input$x.var, input$y.var, input$z.var)
      {
      #
      #
      #
      if(input$z.var == "wilcox")
        {
        #
        #
        #
        wilcox.test(x = stat.dataset()[[input$x.var]], y = stat.dataset()[[input$y.var]])$method
        }
      }
  })
  #
  #
  #
  output$var.results.kruskal.header <- renderText({
    #
    #
    #
    req(input$x.var, input$y.var, input$z.var)
      {
      #
      #
      #
      if(input$z.var == "kruskal")
        {
        #
        #
        #
        kruskal.test(x = stat.dataset()[[input$x.var]], g = stat.dataset()[[input$y.var]])$method
        }
      }
  })
  #
  #
  #
  output$var.results.t.description <- renderText({
    #
    #
    #
    req(input$x.var, input$y.var, input$z.var)
      {
      #
      #
      #
      if(input$z.var == "t.test")
        {
        #
        #
        #    
        paste("Variance between ", input$x.var, " and ", input$y.var, sep = "")
        }
      }
  })
  #
  #
  #
  output$var.results.wilcox.description <- renderText({
    #
    #
    #
    req(input$x.var, input$y.var, input$z.var)
      {
      #
      #
      #
      if(input$z.var == "wilcox")
        {
        #
        #
        #    
        paste("Variance between ", input$x.var, " and ", input$y.var, sep = "")
        }
      }
  })
  #
  #
  #
  output$var.results.kruskal.description <- renderText({
    #
    #
    #
    req(input$x.var, input$y.var, input$z.var)
      {
      #
      #
      #
      if(input$z.var == "kruskal")
        {
        #
        #
        #    
        paste("Variance between ", input$x.var, " and ", input$y.var, sep = "")
        }
      }
  })
  #
  #
  #
  output$x.odds <- renderUI({
    #
    #
    #
    selectInput(inputId = "x.odds",
                label = "Exposure / Predictor",
                choices = c(Select = "", names(stat.dataset())),
                multiple = FALSE,
                selected = "")
    })
  #
  #
  #
  output$y.odds <- renderUI({
    #
    #
    #
    selectInput(inputId = "y.odds",
                label = "Outcome",
                choices = c(Select = "", names(stat.dataset())),
                multiple = FALSE,
                selected = "")
  })
  #
  #
  #
  output$odds.table <- renderTable({
    #
    #
    #
    req(input$x.odds, input$y.odds)
      {
      #
      #
      #
      temp <- riskratio(stat.dataset()[[input$x.odds]], stat.dataset()[[input$y.odds]])
      #
      #
      #
      odds.df <- data.frame(c(paste(input$x.odds, " = 0", sep = ""), paste(input$y.odds, " = 1", sep = ""), "Total"), temp$data)
      #
      #
      #
      names(odds.df) <- c("Variable", paste(input$y.odds, " = ", 0, sep = ""), paste(input$y.odds, " = ", 1, sep = ""), "Total")      
      #
      #
      #
      odds.df
      }
  })         
  #
  #
  #
  output$odds.results <- renderTable({
    #
    #
    #
    req(input$x.odds, input$y.odds)
      {
      #
      #
      #
      temp <- table(stat.dataset()[[input$x.odds]], stat.dataset()[[input$y.odds]])
      #
      #
      #
      odds.ratio <- fisher.test(temp)
      #
      #
      #
      ci <- paste(round(odds.ratio$conf.int[1], digits = 2), " to ", round(odds.ratio$conf.int[2], digits = 2), sep = "")
      #
      #
      #
      results.vector <- c(round(odds.ratio$estimate, digits = 4),
                          ci,
                          round(odds.ratio$p.value, digits = 4))
      #
      #
      #
      results.name <- c("Odds ratio", "95% CI", "p-value")
      #
      #
      #
      odds.table <- data.frame(results.name, results.vector)
      #
      #
      #
      names(odds.table) <- c("Parameters", "Values")
      #
      #
      #
      odds.table
      }
  })         
  #
  #
  #
  output$odds.results.header <- renderText({
    #
    #
    #
    req(input$x.odds, input$y.odds)
      {
      #
      #
      #
      temp <- table(stat.dataset()[[input$x.odds]], stat.dataset()[[input$y.odds]])
      #
      #
      #
      fisher.test(temp)$method
      }
  })
  #
  #
  #
  output$odds.results.description <- renderText({
    #
    #
    #
    req(input$x.odds, input$y.odds)
      {
      #
      #
      #
      paste("Odds of ", input$y.odds, " given ", input$x.odds, sep = "")
      }
  })
  #
  #
  #
  output$x.risk <- renderUI({
    #
    #
    #
    selectInput(inputId = "x.risk",
                label = "Exposure / Predictor",
                choices = c(Select = "", names(stat.dataset())),
                multiple = FALSE,
                selected = "")
    })
  #
  #
  #
  output$y.risk <- renderUI({
    #
    #
    #
    selectInput(inputId = "y.risk",
                label = "Outcome",
                choices = c(Select = "", names(stat.dataset())),
                multiple = FALSE,
                selected = "")
  })
  #
  #
  #
  output$risk.table <- renderTable({
    #
    #
    #
    req(input$x.risk, input$y.risk, input$z.risk)
      {
      #
      #
      #
      temp <- riskratio(x = stat.dataset()[[input$x.risk]], 
                        y = stat.dataset()[[input$y.risk]], 
                        method = input$z.risk)
      #
      #
      #
      risk.df <- data.frame(c(paste(input$x.risk, " = 0", sep = ""), 
                              paste(input$x.risk, " = 1", sep = ""), 
                              "Total"), 
                            temp$data)
      #
      #
      #
      names(risk.df) <- c("Variables", 
                          paste(input$y.risk, " = 0", sep = ""), 
                          paste(input$y.risk, " = 1", sep = ""), 
                          "Total")
      #
      #
      #
      risk.df
      }
  })      
  #
  #
  #
  output$risk.results <- renderTable({
    #
    #
    #
    req(input$x.risk, input$y.risk, input$z.risk)
      {
      #
      #
      #
      temp <- riskratio(x = stat.dataset()[[input$x.risk]], 
                        y = stat.dataset()[[input$y.risk]], 
                        method = input$z.risk)
      #
      #
      #
      results.vector <- c(round(temp$measure[2,1], digits = 4), round(temp$p.value[2,1], digits = 4),
                          paste(round(temp$measure[2,2], digits = 2), " to ", round(temp$measure[2,3], digits = 2)))
      #
      #
      #
      results.name <- c("Risk ratio", "p-value", "95% CI")
      #
      #
      #
      risk.table <- data.frame(results.name, results.vector)
      #
      #
      #
      names(risk.table) <- c("Parameters", "Values")
      #
      #
      #
      risk.table
      }
  })
  #
  #
  #
  output$risk.results.header <- renderText({
    #
    #
    #
    req(input$x.risk, input$y.risk, input$z.risk)
      {
      #
      #
      #
      temp <- riskratio(x = stat.dataset()[[input$x.risk]], 
                        y = stat.dataset()[[input$y.risk]], 
                        method = input$z.risk)
      #
      #
      #
      attr(temp, "method")
      }
  })
  #
  #
  #
  output$risk.results.description <- renderText({
    #
    #
    #
    req(input$x.risk, input$y.risk, input$z.risk)
      {
      #
      #
      #
      paste("Risk of ", input$y.odds, " given ", input$x.odds, sep = "")
      }
  })
  #
  #
  #
  observeEvent(input$refresh.stats, {
    #
    #
    #
    shinyjs::reset("stats.test")
  })
  #
  #
  #
  observeEvent(input$refresh.chart.settings, {
    #
    #
    #
    shinyjs::reset("controls")
  })
  #
  #
  #
  observeEvent(input$refresh.map.settings, {
    #
    #
    #
    shinyjs::reset("controls")
  })


################################################################################
#
# View uploaded maps
#
################################################################################
  #
  #
  #
  output$map.upload <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = get(input$mapbox.settings),
        attribution = "Maps by <a href='http://www.mapbox.com/'>Mapbox</a>"
      ) %>%
      setView(lng = 20, lat = 20, zoom = 3)
  })
  #
  # Get map centre and/or bounds of selected city
  #
  survey.upload <- reactive({
    #
    #
    #
    if(input$map.settings != ".") {
      #
      #
      #
      geocode(input$map.settings, output = "more")
    }
  })
  #
  # Zoom in to selected city
  #
  observe({
    #
    #
    #
    leafletProxy("map.upload") %>%
    #
    #
    #
    fitBounds(lng1 = survey.upload()$east, lat1 = survey.upload()$north,
  		      lng2 = survey.upload()$west, lat2 = survey.upload()$south)
  })  
  #
  # Zoom in to selected city
  #
  observeEvent(input$mapbox.settings != "mapbox.northstar", {
    #
    #
    #
    leafletProxy("map.upload") %>%
    #
    #
    #
    fitBounds(lng1 = survey.upload()$east, lat1 = survey.upload()$north,
  		      lng2 = survey.upload()$west, lat2 = survey.upload()$south)
  })  
  #
  #
  #
  survey.upload.dhaka <- reactive({
    #
    # If selected country is Bangladesh and selected city is Dhaka
    #
    if(input$map.settings == "dhaka")
      {
      #
      #
      #
      inputFile <- input$shp.dhaka
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(dhaka.map) }
      #
      #
      #
      infiles <- inputFile$datapath
      dir <- unique(dirname(infiles))
      outfiles <- file.path(dir, inputFile$name)
      purrr:::walk2(infiles, outfiles, ~file.rename(.x, .y))
      #
      # Read shapefile
      #
      x <- try(readOGR(dsn = dir, 
                       layer = strsplit(inputFile$name[1], "\\.")[[1]][1], 
                       verbose = FALSE),
               silent = TRUE)
      #
      # If uploaded file is readable...
      #
      if(class(x) == "try-error")
        {
        return(NULL) 
        } 
      else 
        {
        #
        # Transform shapefiles into WGS84 longlat
        #
        x <- spTransform(x = x, CRSobj = CRS(long.lat.crs))
        }
      }
  })
  #
  #
  #
  survey.upload.accra <- reactive({
    #
    # If selected country is Ghana and selected city is Accra
    #
    if(input$map.settings == "accra")
      {
      #
      #
      #
      inputFile <- input$shp.accra
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(accra.map) }
      #
      #
      #
      infiles <- inputFile$datapath
      dir <- unique(dirname(infiles))
      outfiles <- file.path(dir, inputFile$name)
      purrr:::walk2(infiles, outfiles, ~file.rename(.x, .y))
      #
      # Read shapefile
      #
      x <- try(readOGR(dsn = dir, 
                       layer = strsplit(inputFile$name[1], "\\.")[[1]][1],
                        verbose = FALSE),
               silent = TRUE)
      #
      # If uploaded file is readable...
      #
      if(class(x) == "try-error")
        {
        NULL 
        } 
      else 
        {
        #
        # Transform shapefiles into WGS84 longlat
        #
        x <- spTransform(x = x, CRSobj = CRS(long.lat.crs))
        }
      }
    })
  #
  #
  #
  survey.upload.nakuru <- reactive({    
    #
    # If selected country is Kenya and selected city is Nakuru
    #
    if(input$map.settings == "nakuru")
      {
      #
      #
      #
      inputFile <- input$shp.nakuru
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(nakuru.map) }
      #
      #
      #
      infiles <- inputFile$datapath
      dir <- unique(dirname(infiles))
      outfiles <- file.path(dir, inputFile$name)
      purrr:::walk2(infiles, outfiles, ~file.rename(.x, .y))
      #
      # Read shapefile
      #
      x <- try(readOGR(dsn = dir, 
                       layer = strsplit(inputFile$name[1], "\\.")[[1]][1],
                       verbose = FALSE),
               silent = TRUE)
      #
      # If uploaded file is readable...
      #
      if(class(x) == "try-error")
        {
        NULL 
        } 
      else 
        {
        #
        # Transform shapefiles into WGS84 longlat
        #
        x <- spTransform(x = x, CRSobj = CRS(long.lat.crs))
        }
      }
    })
  #
  #
  #
  survey.upload.antananarivo <- reactive({   
    #
    # If selected country is Madagascar and selected city is Antananarivo
    #
    if(input$map.settings == "antananarivo")
      {
      #
      #
      #
      inputFile <- input$shp.antananarivo
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(antananarivo.map) }
      #
      #
      #
      infiles <- inputFile$datapath
      dir <- unique(dirname(infiles))
      outfiles <- file.path(dir, inputFile$name)
      purrr:::walk2(infiles, outfiles, ~file.rename(.x, .y))
      #
      # Read shapefile
      #
      x <- try(readOGR(dsn = dir, 
                       layer = strsplit(inputFile$name[1], "\\.")[[1]][1], 
                       verbose = FALSE),
               silent = TRUE)
      #
      # If uploaded file is readable...
      #
      if(class(x) == "try-error")
        {
        NULL 
        } 
      else 
        {
        #
        # Transform shapefiles into WGS84 longlat
        #
        x <- spTransform(x = x, CRSobj = CRS(long.lat.crs))
        }
      }
    })
  #
  #
  #
  survey.upload.maputo <- reactive({
    #
    # If selected country is Mozambique and selected city is Maputo
    #
    if(input$map.settings == "maputo")
      {
      #
      #
      #
      inputFile <- input$shp.maputo
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(maputo.map) }
      #
      #
      #
      infiles <- inputFile$datapath
      dir <- unique(dirname(infiles))
      outfiles <- file.path(dir, inputFile$name)
      purrr:::walk2(infiles, outfiles, ~file.rename(.x, .y))
      #
      # Read shapefile
      #
      x <- try(readOGR(dsn = dir, 
                       layer = strsplit(inputFile$name[1], "\\.")[[1]][1], 
                       verbose = FALSE),
               silent = TRUE)
      #
      # If uploaded file is readable...
      #
      if(class(x) == "try-error")
        {
        NULL 
        } 
      else 
        {
        #
        # Transform shapefiles into WGS84 longlat
        #
        x <- spTransform(x = x, CRSobj = CRS(long.lat.crs))
        }
      }
    })
  #
  #
  #
  survey.upload.lusaka <- reactive({    
    #
    # If selected country is Zambia and selected city is Lusaka
    #
    if(input$map.settings == "lusaka")
      {
      #
      #
      #
      inputFile <- input$shp.lusaka
      #
      # If no map is uploaded, use pre-loaded map
      #
      if(is.null(inputFile)) { return(lusaka.map) }
      #
      #
      #
      infiles <- inputFile$datapath
      dir <- unique(dirname(infiles))
      outfiles <- file.path(dir, inputFile$name)
      purrr:::walk2(infiles, outfiles, ~file.rename(.x, .y))
      #
      # Read shapefile
      #
      x <- try(readOGR(dsn = dir, 
                       layer = strsplit(inputFile$name[1], "\\.")[[1]][1],
                       verbose = FALSE),
               silent = TRUE)
      #
      # If uploaded file is readable...
      #
      if(class(x) == "try-error")
        {
        NULL 
        } 
      else 
        {
        #
        # Transform shapefiles into WGS84 longlat
        #
        x <- spTransform(x = x, CRSobj = CRS(long.lat.crs))
        }
      }
  })
  #
  # Draw uploaded map
  #
  observe({
    #
    #
    #
    if(!is.null(input$shp.dhaka) & input$map.settings == "dhaka")
      {
      #
      #
      #
      leafletProxy("map.upload") %>%
      #
      #
      #
      clearShapes() %>%
      #
      #
      #
      addTiles(
        urlTemplate = get(input$mapbox.settings),
        attribution = "Maps by <a href = 'http://www.mapbox.com/'>Mapbox</a>"
      ) %>%      
      #
      #
      #
      fitBounds(lng1 = bbox(survey.upload.dhaka())[1,1], 
                lat1 = bbox(survey.upload.dhaka())[2,1],
  	  	        lng2 = bbox(survey.upload.dhaka())[1,2], 
  	  	        lat2 = bbox(survey.upload.dhaka())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = survey.upload.dhaka(),
	    weight = 4,
	    opacity = 1,
	    color = "#2C3E50",
	    dashArray = "",
	    fillOpacity = 0.3,
	    highlight = highlightOptions(
	      weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0.3,
		  bringToFront = FALSE))
	  }
    #
    #
    #
    if(!is.null(input$shp.accra) & input$map.settings == "accra")
      {
      #
      #
      #
      leafletProxy("map.upload") %>%
      #
      #
      #
      clearShapes() %>%
      #
      #
      #
      addTiles(
        urlTemplate = get(input$mapbox.settings),
        attribution = "Maps by <a href = 'http://www.mapbox.com/'>Mapbox</a>"
      ) %>%      
      #
      #
      #
      fitBounds(lng1 = bbox(survey.upload.accra())[1,1], 
                lat1 = bbox(survey.upload.accra())[2,1],
  	  	        lng2 = bbox(survey.upload.accra())[1,2], 
  	  	        lat2 = bbox(survey.upload.accra())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = survey.upload.accra(),
	    weight = 4,
	    opacity = 1,
	    color = "#2C3E50",
	    dashArray = "",
	    fillOpacity = 0.3,
	    highlight = highlightOptions(
	      weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0.3,
		  bringToFront = FALSE))
	  }
    #
    #
    #
    if(!is.null(input$shp.nakuru) & input$map.settings == "nakuru")
      {
      #
      #
      #
      leafletProxy("map.upload") %>%
      #
      #
      #
      clearShapes() %>%
      #
      #
      #
      addTiles(
        urlTemplate = get(input$mapbox.settings),
        attribution = "Maps by <a href = 'http://www.mapbox.com/'>Mapbox</a>"
      ) %>%      
      #
      #
      #
      fitBounds(lng1 = bbox(survey.upload.nakuru())[1,1], 
                lat1 = bbox(survey.upload.nakuru())[2,1],
  	  	        lng2 = bbox(survey.upload.nakuru())[1,2], 
  	  	        lat2 = bbox(survey.upload.nakuru())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = survey.upload.nakuru(),
	    weight = 4,
	    opacity = 1,
	    color = "#2C3E50",
	    dashArray = "",
	    fillOpacity = 0.3,
	    highlight = highlightOptions(
	      weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0.3,
		  bringToFront = FALSE))
	  }
    #
    #
    #
    if(!is.null(input$shp.antananarivo) & input$map.settings == "antananarivo")
      {
      #
      #
      #
      leafletProxy("map.upload") %>%
      #
      #
      #
      clearShapes() %>%
      #
      #
      #
      addTiles(
        urlTemplate = get(input$mapbox.settings),
        attribution = "Maps by <a href = 'http://www.mapbox.com/'>Mapbox</a>"
      ) %>%      
      #
      #
      #
      fitBounds(lng1 = bbox(survey.upload.antananarivo())[1,1], 
                lat1 = bbox(survey.upload.antananarivo())[2,1],
  	  	        lng2 = bbox(survey.upload.antananarivo())[1,2], 
  	  	        lat2 = bbox(survey.upload.antananarivo())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = survey.upload.antananarivo(),
	    weight = 4,
	    opacity = 1,
	    color = "#2C3E50",
	    dashArray = "",
	    fillOpacity = 0.3,
	    highlight = highlightOptions(
	      weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0.3,
		  bringToFront = FALSE))
	  }
    #
    #
    #
    if(!is.null(input$shp.maputo) & input$map.settings == "maputo")
      {
      #
      #
      #
      leafletProxy("map.upload") %>%
      #
      #
      #
      clearShapes() %>%
      #
      #
      #
      addTiles(
        urlTemplate = get(input$mapbox.settings),
        attribution = "Maps by <a href = 'http://www.mapbox.com/'>Mapbox</a>"
      ) %>%      
      #
      #
      #
      fitBounds(lng1 = bbox(survey.upload.maputo())[1,1], 
                lat1 = bbox(survey.upload.maputo())[2,1],
  	  	        lng2 = bbox(survey.upload.maputo())[1,2], 
  	  	        lat2 = bbox(survey.upload.maputo())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = survey.upload.maputo(),
	    weight = 4,
	    opacity = 1,
	    color = "#2C3E50",
	    dashArray = "",
	    fillOpacity = 0.3,
	    highlight = highlightOptions(
	      weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0.3,
		  bringToFront = FALSE))
	  }
    #
    #
    #
    if(!is.null(input$shp.lusaka) & input$map.settings == "lusaka")
      {
      #
      #
      #
      leafletProxy("map.upload") %>%
      #
      #
      #
      clearShapes() %>%
      #
      #
      #
      addTiles(
        urlTemplate = get(input$mapbox.settings),
        attribution = "Maps by <a href = 'http://www.mapbox.com/'>Mapbox</a>"
      ) %>%      
      #
      #
      #
      fitBounds(lng1 = bbox(survey.upload.lusaka())[1,1], 
                lat1 = bbox(survey.upload.lusaka())[2,1],
  	  	        lng2 = bbox(survey.upload.lusaka())[1,2], 
  	  	        lat2 = bbox(survey.upload.lusaka())[2,2]) %>%
      #
      # Add survey area polygon layer
      #
	  addPolygons(
	    data = survey.upload.lusaka(),
	    weight = 4,
	    opacity = 1,
	    color = "#2C3E50",
	    dashArray = "",
	    fillOpacity = 0.3,
	    highlight = highlightOptions(
	      weight = 4,
		  color = "#666",
		  dashArray = "",
		  fillOpacity = 0.3,
		  bringToFront = FALSE))
	  }
  })  

################################################################################
#
#
#
################################################################################
  #
  #
  #
  output$select.dhaka.id <- renderUI({
    #
    #
    #
    if(!is.null(input$shp.dhaka) & input$map.settings == "dhaka")
      {
      #
      #
      #
      selectInput(inputId = "survey.area.id",
                  label = "Select map data identifier for survey areas",
                  choices = c(Select = ".", names(survey.upload.dhaka())),
                  selected = ".",
                  width = "100%")
      }
  })  
  #
  #
  #
  output$select.accra.id <- renderUI({
    #
    #
    #
    if(!is.null(input$shp.accra) & input$map.settings == "accra")
      {
      #
      #
      #
      selectInput(inputId = "survey.area.id",
                  label = "Select map data identifier for survey areas",
                  choices = c(Select = ".", names(survey.upload.accra())),
                  selected = ".",
                  width = "100%")
      }
  })  
  #
  #
  #
  output$select.nakuru.id <- renderUI({
    #
    #
    #
    if(!is.null(input$shp.nakuru) & input$map.settings == "nakuru")
      {
      #
      #
      #
      selectInput(inputId = "survey.area.id",
                  label = "Select map data identifier for survey areas",
                  choices = c(Select = ".", names(survey.upload.nakuru())),
                  selected = ".",
                  width = "100%")
      }
  })  
  #
  #
  #
  output$select.antananarivo.id <- renderUI({
    #
    #
    #
    if(!is.null(input$shp.antananarivo) & input$map.settings == "antananarivo")
      {
      #
      #
      #
      selectInput(inputId = "survey.area.id",
                  label = "Select map data identifier for survey areas",
                  choices = c(Select = ".", names(survey.upload.antananarivo())),
                  selected = ".",
                  width = "100%")
      }
  })  
  #
  #
  #
  output$select.maputo.id <- renderUI({
    #
    #
    #
    if(!is.null(input$shp.maputo) & input$map.settings == "maputo")
      {
      #
      #
      #
      selectInput(inputId = "survey.area.id",
                  label = "Select map data identifier for survey areas",
                  choices = c(Select = ".", names(survey.upload.maputo())),
                  selected = ".",
                  width = "100%")
      }
  })  
  #
  #
  #
  output$select.lusaka.id <- renderUI({
    #
    #
    #
    if(!is.null(input$shp.lusaka) & input$map.settings == "lusaka")
      {
      #
      #
      #
      selectInput(inputId = "survey.area.id",
                  label = "Select map data identifier for survey areas",
                  choices = c(Select = ".", names(survey.upload.lusaka())),
                  selected = ".",
                  width = "100%")
      }
  })  
  #
  #
  #
  output$map.selected <- renderLeaflet({
    leaflet(options = leafletOptions(zoomControl = FALSE, dragging = FALSE)) %>%
      addTiles(
        urlTemplate = ifelse(input$map.page == "home", get(input$mapbox.home), get(input$mapbox.settings)),
        attribution = "Maps by <a href='http://www.mapbox.com/' target = '_blank'>Mapbox</a>"
      ) %>%
      setView(lng = 20, lat = 20, zoom = 2)
  })


################################################################################
#
# Modal dialogs
#
################################################################################
  #
  #
  #
  observeEvent(input$info1, {
    #
    #
    #
    showModal(
      #
      #
      #
      modalDialog(
        #
        #
        #
        withMathJax(),
		  title = "Chart Options",
		  size = "l",
		  HTML("
			<h4>Country</h4>
			<p>Choose country data to visualise. The choices of countries to select from is based on the pre-loaded or user-provided data</p>
			<br/>
			
			<h4>City</h4>
			<p>Choose city data to visualise. The choices of cities to select from is based on the country selected and on the pre-loaded or user-provided data</p>
			<br/>
			
			<h4>From - To</h4>
			<p>Choose year/s of data to visualise. The range of years to select from is based on the country and city selected and on the pre-loaded or user-provided data</p>
			<br/>
			
			<h4>Select indicator set</h4>
			<p>Indicators for the <code>Urban Water and Sanitation Survey</code> are organised into thirteen indicator sets. These are: 1) <em>Demographics</em>; 2) <em>Types of Water Sources</em>; 3) <em>Access to Water Sources</em>; 4) <em>Other Water Indicators</em>; 5) <em>Types of Sanitation Facilities</em>; 6) <em>Access to Sanitation Facilities</em>; 7) <em>Sanitation Practices and Behaviours</em>; 8) <em>Other Sanitation Indicators</em>; 9) <em>Women Hygiene</em>; 10) <em>Handwashing</em>; 11) <em>Access to All Services</em>; 12) <em>Overall Expenditure</em>; and, 13) <em>Poverty</em>.</p>
			<br/>
			
			<h4>Select Indicator</h4>
			<p><strong>Mean number of household members</strong></p>
			<p>This indicator is based on the self-report of number of household members.</p>

			<br/>                    
			<p><strong>Progress out of Poverty Index (PPI)</strong></p>
			<p>The <code>Progress out of Poverty Index (PPI)</code> is a measure of poverty developed by <a href='http://www.grameenfoundation.org' target='_blank'>Grameen Foundation</a> in collaboration with the <a href='https://www.fordfoundation.org' target='_blank'>Ford Foundation</a>, and managed by the <a href'http://www.poverty-action.org' target='_blank'>Innovations for Poverty Action</a>. The first <code>PPI</code> was released in 2006 and has since then been customised for 45 countries. The <code>PPI</code> is based on a country-specific 10-item questionnaire about a household’s characteristics and asset ownership which is scored to compute the likelihood that a household is living below country-specific and universal poverty line thresholds.</p>

			<br/>                            
			<p><strong>Poverty Likelihood ($1.25 a day)</strong></p>
			<p>This is the measure of the probability that a household is below the <code>$1.25 purchasing power parity (PPP)</code> poverty threshold of 2005. The likelihood is determined through pre-calculated and country-specific probabilites based on the household <code>PPI</code>. Other <code>PPI</code>-based poverty likelihoods using other country-specific and or global poverty thresholds are available.</p> 
			
			<br/>                            
			<p><strong>Wealth Quintile</strong></p>
			<p>This is the classification or grouping of each household into quintiles based on <code>PPI</code> with those in the lowest quintile (wealth quintile 1) having the lowest fifth <code>PPI</code> and those in the highest quintile (wealth quintile 5) having the highest fifth <code>PPI</code>.</p>

			<br/>
			<p><strong>Types of Water Sources</strong></p>
			<p><code>Safely managed:</code> Drinking water from an improved water source which is located on premises, available when needed and free of faecal and priority contamination. </p>
			<p><code>Basic:</code> Drinking water from an improved source provided collection time is not more than 30 minutes for a roundtrip including queuing.</p> 
			<p><code>Limited:</code> Drinking water from an improved source where collection time exceeds over 30 minutes for a roundtrip to collect water, including queuing.</p>
			<p><code>Unimproved:</code> Drinking water from an unimproved dug well or unprotected spring</p>
			<p><code>Surface water:</code> Drinking water directly from a river, dam, lake, pond, stream, canal or irrigation channel.</p>

			<br/>
			<p><strong>Access to sufficient and sustained drinking water</strong></p>
			<p><code>Percentage of households with access to sufficient and sustained drinking water</code>: Sufficient is defined as <code>50 litres per person per day</code>. Sustained is defined as drinking water available <code>24 hours per day</code>, <code>7 days a week</code> and <code>throughout the year</code>.</p>

			<br/>                                                          
			<p><strong>Access to safe and acceptable drinking water for all</strong></p>
			<p><code>Percentage of households with good self-reported quality of drinking water:</code> No objective water quality assessment was performed during the survey. This indicator, as stated, is based on self-reported perception of water quality.</p>
			<p><code>Percentage of households that are safely storing drinking water:</code> Safe storage is defined as drinking water stored in a clean container with lid only.</p>

			<br/>                                  
			<p><strong>Access to affordable drinking water</strong></p>
			<p><code>Mean expenditure in drinking water by wealth quintile:</code> mean expenditure in drinking water per household per year by wealth quintile. It should be noted that expenditure alone does not indicate affordable access to drinking water. The ideal and recommened indicator is yearly expenditure on water as a fraction of annual income i.e., \\(\\frac{\\mu_\\text{Household yearly expenditure on water}}{\\text{Household annual income}}\\). However, the surveys did not collect data on household income hence this recommended indicator cannot be calculated.</p>

			<br/>                                                         
			<p><strong>Physical access to drinking water</strong></p>                             
			<p><code>Percentage of households with adequate physical access to drinking water:</code> Adequate physical access is defined as source of drinking water is located within <code>30 minutes</code> from home</p>

			<br/>                                                          
			<p><strong>Formal water service provision</strong></p>
			<p><code>Percentage of households with formal drinking water service provision:</code> Formal drinking water service provision is defined as drinking water provided by a formal service according to interviewer asessment.</p>
			<p><code>Percentage of households relying on formal provider for service supply maintenance:</code> Formal provider for service supply maintenance is defined as a household with a formal service provider contact person in case of problems with water supply.</p>

			<br/>
			<p><strong>Sanitation Service Ladder</strong></p>       
			<p><code>Safely managed:</code> Use of an improved sanitation facility which is not shared with other households and where excreta are safely disposed in situ or transported and treated off-site.</p>
			<p><code>Basic:</code> Use of improved facilities which are not shared with other households.</p>
			<p><code>Limited:</code> Use of improved facilities shared between two or more households.</p>
			<p><code>Unimproved:</code> Use of pit latrines wihtout a slab or platform, hanging latrines and bucket latrines</p>
			<p><code>Open defecation:</code> Disposal of human faeces in fields, forest, bushes, open bodies of water, beaches or other open spaces or with solid waste.</p>

			<br/>
			<p><strong>Use of adequate hygienic materials for menstrual hygiene management</strong></p>
			<p><code>Percentage of households using adequate hygienic materials foe MHM</code>: Adequate hygienic maetrials are cloths, pads, tampons or menstrual cups</p>
										  
			<br/>
			<p><strong>Hygienic and adequate disposal of menstrual hygiene materials</strong></p>
			<p><code>Percentage of households practicing good mentrual hygiene practies/behaviour:</code> Good menstrual hygiene management includes cloths washed with soap and water and napkins/pads disposed of in the rubbish bin.</p>

			<br/> 
			<p><strong>Comfort with sanitation facilities during menstruation</strong></p>
			<p><code>Percentage of households in which women and girls are comfortable using sanitation facility during menstruation:</code></p>                             

			<br/>
			<p><strong>Overall access to adequate water and sanitation services</strong></p>
			<p><code>Percentage of Households with access to adequate water and sanitation services by quintile</code>: Adequate water services and adequate sanitation services as defined.</p>
			<ul>
			  <li>Percentage of households with access to adequate sanitation and adequate drinking water</li>
			  <li>Percentage of households with access to adequate sanitation only</li>
			  <li>Percentage of households with access to adequate drinking water only</li>
			  <li>Percentage of households with no access to adequate services</li>
			</ul>
			
			<br/>
			<h4>Disaggregate by</h4>
			<p>Select from choices of data variables to be used for grouping / disaggregating the data. When applied to charts, data is grouped based on the selected variable and then plotted accordingly on a single chart.</p>
			 <ul>
			   <li><code>All Data (No Stratification)</code>: full dataset is used and resulting chart has no facets or panels.</li>
			   <li><code>Survey Area</code>: dataset is grouped into \\(n\\) unique survey areas and resulting chart has \\(n\\) facets or panels corresponding to each survey area.</li>
			   <li><code>Area Type</code>: dataset is grouped into <code>slum</code> and <code>citywide</code> area types and resulting chart has <code>slum</code> and <code>citywide</code> facets or panels.</li>
			   <li><code>Wealth Quintile</code>: dataset is grouped into quintiles based on the <code>Progress out of Poverty Index (PPI)</code>.</li>
			 </ul>
			   
			<br/>                             
			<h4>Stratify by</h4>
			<p>Select from choices of data variables to be used for grouping / disaggregating the data. When applied to charts, \\(n\\) unique values of the selected variables are used to create \\(n\\) facets or panels of the resulting chart.</p>
		  ")))                       
  })
  #
  #
  #
  observeEvent(input$info2, {
    #
    #
    #
    showModal(
      #
      #
      #
      modalDialog(
        #
        #
        #
        withMathJax(),
        #
        #
        #
		title = "Map Options",
		#
		#
		#
		size = "l",
		#
		#
		#
		HTML("
		  <h4>Select colour palette</h4>
			<p>Select from choices of colour palettes to use for mapping. Two categories of colour palettes are available.</p>
			  <ul>
			    <li><code>Sequential</code> palettes are suited to ordered data that progress from low to high with light colours representing low data values and dark colours representing high data values.</li>
			    <li><code>Diverging</code> palettes put equal emphasis on mid-range critical values and extremes at both ends of the data range. The middle values are emphasised with light colours and low and high extremes are emphasised with dark colours that have contrasting hues.</li>
			  </ul>
			
			<p>The choices of colour palettes are based on <a href='http://colorbrewer2.org/' target='_blank'>ColorBrewer 2.0</a> and implemented in R using the <a href='https://cran.r-project.org/web/packages/RColorBrewer/RColorBrewer.pdf' target='_blank'>RColorBrewer</a> function.</p>
			
			<p>The default colour palette for the <code>Demographics</code> indicator set is <code>sequential yellow to orange to brown (YlOrBb)</code> scheme.</p>
			
		  <br/>	
		  <h4>Select colour mapping method</h4>
			<p>Colour mapping methods determine how to match the indicator dataset to the selected colour palette appropriately. Three colour mapping methods are available.</p>
			  <ul>
			    <li><code>Linear interpolation</code> is a simple linear mapping from continuous numeric data to an interpolated colour palette. In this method, the selected colour palette is extended (via interpolation) to create a continuous set of colours consistent with the scheme that would be enough to match the range of values of the continuous numeric data being mapped.</li>
			    <li><code>Equal interval</code> maps continuous numeric data to a fixed number of colours from the palette. The continous indicator values are divided into equal interval group sets determined by the <code>number of bins</code> specified (see below regarding bins). The number of colours correspond to the <code>number of bins</code> into which the indicator values have been divided into.</li>
			    <li><code>Quantile</code> also maps continuous numeric data to a fixed number of colours from the palette. However, the continuous indicator values are divided into <code>quantiles</code> (group sets with equal number of observations). The number of colours correspond to the <code>number of quantiles</code> into which the indicator values have been divided into.</li> 
			  </ul>
			
		  <br/>                            
		  <h4>Number of bins</h4>
			<p><em>For equal interval method.</em> Select number of equal interval groups to divide the dataset into. For example, for a dataset of percentages with values ranging between 0 and 100, specifying <code>number of bins</code> to 5 would mean creating 5 equal interval groupings - <code>[0,20)</code>, <code>[20, 40)</code>, <code>[40,60)</code>, <code>[60,80)</code>, <code>[80,100]</code></p>
			
		  <br/>
		  <h4>Number of classes</h4>
			<p><em>For quantile method.</em> Select number of quantiles to divide dataset into.</p>
		  ")))                       
  })
  #
  #
  #
  observeEvent(input$info3, {
     #
     #
     #
     showModal(
       #
       #
       #
       modalDialog(
         #
         #
         #
         withMathJax(),
		 #
		 #
		 #  
		 title = "City map data input",
		 #
		 #
		 #
		 size = "l",
		 #
		 #
		 #
		 HTML("
		   <h4>Upload map of citywide survey area</h4>
			 <p>The map should be in ESRI Shapefile format (SHP). This file format requires a minimum of 3 related files in order to be readable. These files are the <code>.SHP</code>, <code>.SHX</code> and <code>.DBF</code>. Hence, these three files should be uploaded all at the same time by clicking on CTRL and then selecting at least the three files for upload. A warning will pop out if the incorrect file formats and/or incomplete number of files are uploaded. Once the files have been uploaded, two new options come out. First, the app asks for the vaiable name in the map files that contains the stratifying variable. This would be the variable name of a geographic subdivision by which you decided to divide the city. Second, a prompt for the number of primary sampilng units or <code>PSU</code> comes to view. This is set at a default of 30. Once you have specified these parameters, you can click on <code>Sample</code> and corresponding sampling maps will be produced on the main panel and corresponding sampling lists on the appropriate sampling tabs.</p>
	     ")))
  })
  #
  #
  #
  observeEvent(input$info4, {
     #
     #
     #
     showModal(
       #
       #
       #
       modalDialog(
         #
         #
         #
         withMathJax(),
		 #
		 #
         #  
		 title = "Low income area map data input",
		 #
		 #
		 #
		 size = "l",
		 #
		 #
		 #
		 HTML("
		   <h4>Available low income area sampling information</h4>
			 <p>For low income areas, you are first asked what information you have on low income areas that can be used for sampling: <code>low income area maps</code> or <code>low income area lists</code>. If you have low income area maps, then you are given the options for sampling with low income area maps (below). If you have lists, then you are given the option for sampling with low income area lists (below).</p>
			 
		   <br/>
		   <h4>Upload map of low income survey area</h4>
			 <p>The map should be in ESRI Shapefile format (SHP). This file format requires a minimum of 3 related files in order to be readable. These files are the <code>.SHP</code>, <code>.SHX</code> and <code>.DBF</code>. Hence, these three files should be uploaded all at the same time by clicking on CTRL and then selecting at least the three files for upload. A warning will pop out if the incorrect file formats and/or incomplete number of files are uploaded. Once the files have been uploaded, two new options come out. First, the app asks for the vaiable name in the map files that contains the stratifying variable. This would be the variable name of a geographic subdivision by which you decided to divide the city. Second, a prompt for the number of primary sampilng units or <code>PSU</code> comes to view. This is set at a default of 30. Once you have specified these parameters, you can click on <code>Sample</code> and corresponding sampling maps will be produced on the main panel and corresponding sampling lists on the appropriate sampling tabs.</p>

		   <br/>
		   <h4>Upload list of low income areas</h4>
			 <p>The list of low income areas should be in CSV format. The list should be organised and sorted along the stratifying variable for survey areas. Once the list has been uploaded, you will need to specify how many <code>PSUs</code> will be survyed. Then press on <code>Sample</code>. A sample list from the complete list is now available on the <code>Low Income Area Lists</code> tab.</p>
		 ")))
  })
  #
  #
  #
  observeEvent(input$info5, {
     #
     #
     #
     showModal(
       #
       #
       #
       modalDialog(
         #
         #
         #
         withMathJax(),
		 #
		 #
		 #
		 title = "Statistical Tests",
		 #
		 #
		 #
		 size = "l",
		 #
		 #
		 #
		 HTML("
		   <h4>Correlation</h4>
			 <p>This is a test for association between paired samples, using one of <code>Pearson's</code> product moment correlation coefficient, <code>Kendall's tau</code> or <code>Spearman's rho</code>.</p>
			 
		   <br/>
		   <h4>Variance</h4>
			 <p>This is a test for variance, using <code>Student's t-test</code>, <code>Wilcoxon Rank Sum and Signed Rank Tests</code>, or <code>Kruskal-Wallis Rank Sum Test</code>.</p>

		   <br/>
		   <h4>Odds ratio</h4>
			 <p>Performs <code>Fisher's exact test</code> for testing the null of independence of rows and columns in a contingency table or 2 x 2 table.</p>

		   <br/>
		   <h4>Risk ratio</h4>
			 <p>Calculates risk ratio by unconditional <code>maximum likelihood estimation (Wald)</code>, and <code>small sample adjustment (small)</code>. Confidence intervals are calculated using <code>normal approximation (Wald)</code>, and <code>normal approximation with small sample adjustment (small)</code>, and <code>bootstrap method (boot)</code>.</p>
		 ")))
  })
  #
  #
  #
  observeEvent(input$info6, {
     #
     #
     #
     showModal(
       #
       #
       #
       modalDialog(
         #
         #
         #
         withMathJax(),
         #
         #
         #
		 title = "Correlation test parameters",
		 #
		 #
		 #
		 size = "l",
		 #
		 #
		 #
		 HTML("
		   <h4>Independent variable</h4>
		     <p>The <code>independent variable</code> represents inputs or causes or the potential reasons for variation in the <code>dependent variable</code>.</p>
			 
		   <br/>
		   <h4>Dependent variable</h4>
			 <p>The <code>dependent variable</code> responds to the <code>independent variable</code>. It is called <code>dependent</code> because it <em>depends</em> on the <code>independent variable</code>.</p>

		   <br/>
		   <h4>Type of correlation coefficient</h4>
			 <ul>
			   <li><code>Pearson's <em>r</em></code> : Applies <strong>Pearson's product moment correlation coefficient</strong> calculations. It is a measure of the linear correlation between two variables. It has a value between +1 and −1, where 1 is total positive linear correlation, 0 is no linear correlation, and −1 is total negative linear correlation.</li>
			   <li><code>Kendall's tau</code> : <strong>Kendall's tau</strong> is a statistic used to measure the ordinal association between two measured quantities. A <code>tau test</code> is a non-parametric hypothesis test for statistical dependence based on the <code>tau</code> coefficient. It is a measure of rank correlation: the similarity of the orderings of the data when ranked by each of the quantities. The coefficient must be in the range −1 ≤ tau ≤ 1. If the agreement between the two rankings is perfect (i.e., the two rankings are the same) the coefficient has value 1. If the disagreement between the two rankings is perfect (i.e., one ranking is the reverse of the other) the coefficient has value −1. If X and Y are independent, then we would expect the coefficient to be approximately zero.</li>
			   <li><code>Spearman's rho</code> : <strong>Spearman's rho</strong> is a nonparametric measure of rank correlation (statistical dependence between the ranking of two variables). It assesses how well the relationship between two variables can be described using a monotonic function. The Spearman correlation between two variables will be high when observations have a similar (or identical for a correlation of 1) rank (i.e. relative position label of the observations within the variable: 1st, 2nd, 3rd, etc.) between the two variables, and low when observations have a dissimilar (or fully opposed for a correlation of −1) rank between the two variables. Spearman's coefficient is appropriate for both continuous and discrete variables, including ordinal variables.</li>
			 </ul>
		 ")))
  })
  #
  #
  #
  observeEvent(input$info7, {
     #
     #
     #
     showModal(
       #
       #
       #
       modalDialog(
         #
         #
         #
         withMathJax(),
         #
         #
         #
		 title = "Variance test parameters",
		 #
		 #
		 #
		 size = "l",
		 #
		 #
		 #
		 HTML("
		   <h4>Independent variable</h4>
			 <p>The <code>independent variable</code> represents inputs or causes or the potential reasons for variation in the <code>dependent variable</code>.</p>
			 
		   <br/>
		   <h4>Dependent variable</h4>
			 <p>The <code>dependent variable</code> responds to the <code>independent variable</code>. It is called <code>dependent</code> because it <em>depends</em> on the <code>independent variable</code>.</p>

		   <br/>
		   <h4>Type of variance testing</h4>
		     <ul>
			   <li><code>t-test</code> : A <strong>t-test</strong> is most commonly applied when the test statistic would follow a normal distribution. The t-test can be used, for example, to determine if two sets of data are significantly different from each other.</li>
			   <li><code>Wilcoxon test</code> : The <strong>Wilcoxon signed-rank test</strong> is a non-parametric statistical hypothesis test used when comparing two related samples, matched samples, or repeated measurements on a single sample to assess whether their population mean ranks differ (i.e. it is a paired difference test). It can be used as an alternative to the paired Student's t-test, t-test for matched pairs, or the t-test for dependent samples when the population cannot be assumed to be normally distributed. A Wilcoxon signed-rank test is a nonparametric test that can be used to determine whether two dependent samples were selected from populations having the same distribution.</li>
			   <li><code>Kruskal-Walis test</code> : <strong>Kruskal-Walis test</strong> is a non-parametric method for testing whether samples originate from the same distribution. Since it is a non-parametric method, the Kruskal–Wallis test does not assume a normal distribution of the residuals.</li>
		     </ul>
		 ")))
  })
  #
  #
  #
  observeEvent(input$info8, {
     #
     #
     #
     showModal(
       #
       #
       #
       modalDialog(
         #
         #
         #
         withMathJax(),
         #
         #
         #
		 title = "Odds ratio calculation parameters",
		 #
		 #
         #
         size = "l",
		 #
		 #
         #  
		 HTML("
		   <h4>Exposure / predictor</h4>
		     <p>The term <strong>exposure</strong> can be broadly applied to any factor that may be associated with an outcome of interest. When using observational data sources, researchers often rely on readily available (existing) data elements to identify whether individuals have been exposed to a factor of interest.</p>
			 
			 <br/>
			 <h4>Outcome</h4>
			 <p>The <strong>outcome</strong> is the effect or end result or end point caused and/or contributed to by the exposure or predictor. </p>

			 <br/>
			 <h4>About Odds Ratio</h4>
			   <p>An <code>odds ratio (OR)</code> is a measure of association between an exposure and an outcome. The OR represents the odds that an outcome will occur given a particular exposure, compared to the odds of the outcome occurring in the absence of that exposure. Odds ratios are most commonly used in case-control studies, however they can also be used in cross-sectional and cohort study designs as well (with some modifications and/or assumptions). Odds ratios are used to compare the relative odds of the occurrence of the outcome of interest (e.g. disease or disorder), given exposure to the variable of interest (e.g. health characteristic, aspect of medical history). The odds ratio can also be used to determine whether a particular exposure is a risk factor for a particular outcome, and to compare the magnitude of various risk factors for that outcome.</p>
               <ul>
                 <li><strong>OR = 1</strong> Exposure does not affect odds of outcome</li>
                 <li><strong>OR > 1</strong> Exposure associated with higher odds of outcome</li>
                 <li><strong>OR < 1</strong> Exposure associated with lower odds of outcome</li>
               </ul>
		   ")))
  })
  #
  #
  #
  observeEvent(input$info9, {
     #
     #
     #
     showModal(
       #
       #
       #
       modalDialog(
         #
         #
         #
         withMathJax(),
         #
         #
         #
		 title = "Risk ratio calculation parameters",
		 #
		 #
		 #
		 size = "l",
		 #
		 #
		 #
		 HTML("
		   <h4>Exposure / predictor</h4>
		     <p>The term <strong>exposure</strong> can be broadly applied to any factor that may be associated with an outcome of interest. When using observational data sources, researchers often rely on readily available (existing) data elements to identify whether individuals have been exposed to a factor of interest.</p>
			 
		   <br/>
		   <h4>Outcome</h4>
		     <p>The <strong>outcome</strong> is the effect or end result or end point caused and/or contributed to by the exposure or predictor. </p>

		   <br/>
		   <h4>About Risk Ratio</h4>
		     <p><strongRisk ratio</strong> is the ratio of the probability of an event occurring (for example, developing a disease, being injured) in an exposed group to the probability of the event occurring in a comparison, non-exposed group. Relative risk includes two important features:</p> 
		       <ul>
		        <li>a comparison of risk between two exposures puts risks in context, and;</li>
			    <li>exposure is ensured by having proper denominators for each group representing the exposure</li>
		       </ul>
		   
		     <p>Risk ratio is used frequently in the statistical analysis of binary outcomes where the outcome of interest has relatively low probability. It is thus often suited to clinical trial data, where it is used to compare the risk of developing a disease, in people not receiving the new medical treatment (or receiving a placebo) versus people who are receiving an established (standard of care) treatment.</p>
			   			   
		     <p>In a simple comparison between an experimental group and a control group:</p>
               <ul>
                 <li>A relative risk of 1 means there is no difference in risk between the two groups.</li>
                 <li>An RR of < 1 means the event is less likely to occur in the experimental group than in the control group.</li>
                 <li>An RR of > 1 means the event is more likely to occur in the experimental group than in the control group.</li>
               </ul>
		   ")))
  })
  #
  #
  #
  observeEvent(input$view.table, {
     #
     #
     #
     showModal(
       #
       #
       #
       modalDialog(
         #
         #
         #
         withMathJax(),
         #
         #
         #
         title = paste(input$city, ", ", input$country, " (", year.header(), "): ", steer.indicators()$varNames[steer.indicators()$varList == input$varList], sep = ""),
         #
         #
         #
         size = "l",
         #
         #
         #
         if(!input$varList %in% c("waterSource", "water9", "water10", "water11b", "san1", "san3", "san8", "san20", "san22", "san24", "san35a", "san28a"))
           {
           #
           #
           #
           DT::dataTableOutput("current.sub.table")
           }
         #
         #
         #
         else
           {
           #
           #
           #
           DT::dataTableOutput("current.sub.indicators")           
           }
       )
     )         
  })
}