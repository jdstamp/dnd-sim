library(dplyr)

attack <- function(advantage,
                   ac,
                   attack_mod,
                   dmg_mod,
                   dmg_dice,
                   n_trials = 1e4) {
  attack_check <- sample(1:20, n_trials, replace = TRUE)
  dmg_roll <- sample(1:dmg_dice, n_trials, replace = TRUE)
  crit_roll <- sample(1:dmg_dice, n_trials, replace = TRUE)
  if (advantage) {
    attack_check <- pmax(attack_check, sample(1:20, n_trials, replace = TRUE))
  }
  attack_df <- data.frame(
    ac = ac,
    attack_mod = attack_mod,
    dmg_mod = dmg_mod,
    dmg_roll = dmg_roll,
    crit_roll = crit_roll,
    attack_check = attack_check,
    trial = 1:n_trials
  ) %>%
    mutate(
      is_critical = (attack_check == 20),
      hit = if_else(attack_check > 1, attack_check + attack_mod >= ac, FALSE)
    ) %>%
    mutate(dmg_roll = if_else(hit, dmg_roll, 0)) %>%
    mutate(crit_roll = if_else(is_critical, crit_roll, 0)) %>% 
    mutate(damage = if_else(hit, dmg_roll + crit_roll + dmg_mod, 0))
  
  return(attack_df)
}
