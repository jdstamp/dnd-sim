library(shiny)
library(ggplot2)
library(dplyr)

source("attack.R")
# Define server logic required to draw a histogram ----
server <- function(input, output) {

  one_weapon_attack <- reactive({
    return(attack(input$advantage,
                  input$ac,
                  input$attack_mod,
                  input$dmg_mod,
                  input$dmg_dice))
  })
  
  two_weapon_attack <- reactive({
    first <- attack(input$advantage,
                    input$ac,
                    input$attack_mod,
                    input$dmg_mod_1,
                    input$dmg_dice_1) %>%
      mutate(weapon = 1)
    second <- attack(input$advantage,
                     input$ac,
                     input$attack_mod,
                     input$dmg_mod_2,
                     input$dmg_dice_2) %>%
      mutate(weapon = 2)
    return(rbind(first, second))
  })

  output$one_weapon <- renderPlot({
    rolls <- one_weapon_attack()
    ggplot(rolls, aes(x=damage, y = after_stat(density))) + 
      geom_histogram(binwidth = 1, boundary = 0.5, fill="#900C3F") +
      theme_minimal() +
      labs(
        x = "Damage",
        y = "Probability",
        title = "Damage One-Weapon Fighting"
      )
  })
  output$two_weapon <- renderPlot({
    rolls <- two_weapon_attack()
    ggplot(rolls %>% 
             group_by(trial) %>%
             mutate(total_dmg = sum(damage)), aes(x=total_dmg, y = after_stat(density))) + 
      geom_histogram(binwidth = 1, boundary = 0.5, fill="#900C3F") +
      theme_minimal() +
      labs(
        x = "Damage",
        y = "Probability",
        title = "Damage Two-Weapon Fighting"
      )
  })
  output$one_weapon_mean <- renderText({
    rolls <- one_weapon_attack()
    dmg_mean <- round(mean(rolls$damage), 2)
    paste("Mean damage: ", dmg_mean)
  })
  output$one_weapon_sd <- renderText({
    rolls <- one_weapon_attack()
    dmg_sd <- round(sd(rolls$damage), 2)
    paste("SD damage: ", dmg_sd)
  })
  output$one_weapon_hit <- renderText({
    rolls <- one_weapon_attack()
    hit_rate <- round(mean(rolls$hit), 2)
    paste("Hit rate: ", hit_rate)
  })
  output$two_weapon_mean <- renderText({
    rolls <- two_weapon_attack() %>%
      group_by(trial) %>%
      summarise(damage = sum(damage))
    dmg_mean <- round(mean(rolls$damage), 2)
    paste("Mean damage: ", dmg_mean)
  })
  output$two_weapon_sd <- renderText({
    rolls <- two_weapon_attack() %>%
      group_by(trial) %>%
      summarise(damage = sum(damage))
    dmg_sd <- round(sd(rolls$damage), 2)
    paste("SD damage: ", dmg_sd)
  })
  output$two_weapon_hit <- renderText({
    rolls <- two_weapon_attack() %>%
      group_by(trial) %>%
      summarise(hit = any(hit))
    hit_rate <- round(mean(rolls$hit), 2)
    paste("Hit rate: ", hit_rate)
  })
  
}