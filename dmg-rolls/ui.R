library(shiny)
library(shinydashboard)
library(bslib)

dice_list <- list(
  "D4" = 4,
  "D6" = 6,
  "D8" = 8,
  "D12" = 12,
  "D20" = 20
)

ui <- fluidPage(
  titlePanel("DnD Damage Rolls"),
  fluidRow(column(
    width = 6,
    # Full-width card
    wellPanel(
      h3("Configuration"),
      numericInput("ac", "Target armor class:", 15, min = 1, max = 20),
      numericInput(
        "attack_mod",
        "Attack Modifier:",
        5,
        min = -10,
        max = 10
      ),
      # Checkbox for Advantage
      checkboxInput(
        inputId = "advantage",
        label = "Roll with Advantage",
        value = FALSE  # Default to FALSE
      )
    )
  )),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "dmg_dice",
        label = "Damage Dice:",
        choices = dice_list
      ),
      numericInput(
        "dmg_mod",
        "Damage Modifier:",
        3,
        min = -10,
        max = 10
      ),
    ),
    mainPanel(
      column(width = 9, plotOutput(outputId = "one_weapon")),
      column(
        width = 3,
        # Set the width of the column (6 out of 12 grid)
        h3("Summary"),
        textOutput("one_weapon_mean"),
        textOutput("one_weapon_sd"),
        textOutput("one_weapon_hit")
      )
    )
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "dmg_dice_1",
        label = "1. Damage Dice:",
        choices = dice_list
      ),
      numericInput(
        "dmg_mod_1",
        "1. Damage Modifier:",
        3,
        min = -10,
        max = 10
      ),
      selectInput(
        inputId = "dmg_dice_2",
        label = "2. Damage Dice:",
        choices = dice_list
      ),
      numericInput(
        "dmg_mod_2",
        "1. Damage Modifier:",
        0,
        min = -10,
        max = 10
      ),
    ),
    mainPanel(
      column(width = 9, plotOutput(outputId = "two_weapon")),
      column(
        width = 3,
        # Set the width of the column (6 out of 12 grid)
        h3("Summary"),
        textOutput("two_weapon_mean"),
        textOutput("two_weapon_sd"),
        textOutput("two_weapon_hit")
      )
    )
  )
)
