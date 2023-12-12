library(tidyverse)
library(ggtext)

library(showtext)
## Loading Google fonts (https://fonts.google.com/)
font_add_google("IBM Plex Mono", "ibm")
font_add_google("Roboto", "roboto")

showtext_opts(dpi = 300)
showtext_auto(enable = TRUE)
theme_set(theme_light())

treated_data <- tibble(
    pctile = c(1, 2, 3, 4, 5),
    decile_share = c(0.062, 0.12, 0.17, 0.24, 0.41),
    treated = c("Treated", "Treated", "Treated", "Treated", "Treated"),
) %>%
    mutate(decile_share_lab_treated = scales::percent(decile_share, accuracy = 1))

control_data <- tibble(
    pctile = c(1, 2, 3, 4, 5),
    decile_share = c(0.058, 0.082, 0.13, 0.2, 0.53),
    treated = c("Control", "Control", "Control", "Control", "Control"),
) %>%
    mutate(decile_share_lab_control = scales::percent(decile_share, accuracy = 1))



data <- bind_rows(treated_data, control_data)

data %>%
    ggplot(aes(y = pctile, x = decile_share, colour = treated)) +
    geom_point(cex = 8) +
    geom_line() +
    geom_text(aes(label = decile_share_lab_control), hjust = 1.3, size = 6, colour = "black") +
    geom_text(aes(label = decile_share_lab_treated), hjust = -.5, size = 6, colour = "black") +
    labs(
        x = "Share of total income in parish",
        y = "Percentile of income distribution",
        colour = "Individual's birth parish"
        # title = "Income quintile shares for
        #                  <b><span style = 'color:#9C6114;'>treated</span></b> and
       #                   <b><span style = 'color:#000080;'>control</span></b> individuals"
    ) +
    scale_y_continuous(labels = scales::percent_format(scale = 20)) +
    scale_x_continuous(labels = scales::percent_format(), limits = c(0, NA)) +
    scale_colour_brewer(palette = "Dark2") +
    theme(
        # panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        plot.title = element_markdown(size = 32, family = "roboto"),
        plot.title.position = "plot",
        legend.position = "bottom",
        text = element_text(family = "ibm", size = 18)
    )

ggsave(filename = here::here("figures/07-inequality-plot.jpeg"), device = "jpeg", width = 290, height = 231, units = "mm", dpi = 300)
