### Script for project Exploring the association between psychotic experiences and religious beliefs and behaviours (B4562)
### Script 4: Creating plots
### Created 10/02/2024 by Dan Major-Smith
### R version 4.3.1


###########################################################################################
#### Clear workspace, install/load packages, and set working directory
rm(list = ls())

setwd("X:\\Studies\\RSBB Team\\Dan\\B4562 - PLIKS and RSBB\\Results")

#install.packages("tidyverse")
library(tidyverse)



##########################################################################################
#### Create nice plots for the marginal effects results for RQ1

# Read in results
res <- read_csv("marginal_RQ1.csv")
head(res)


# Process some variables
res <- res %>%
  mutate(contrast = factor(contrast, levels = c("Belief - No", "Belief - Not sure", "Belief - Yes",
                                                "Identity - Religious", "Attend - Regular",
                                                "LCA - 'Atheist'", "LCA - 'Agnostic'", "LCA - 'Moderately religious'",
                                                "LCA - 'Highly religious'"))) %>%
  mutate(model = factor(model, levels = c("CCA", "MI")))
res


# Make the plot
(plot <- ggplot(res, aes(x = contrast, y = est, ymin = lci, ymax = uci, col = model, fill = model)) +
    geom_hline(yintercept = 0, lty = 2) +
    geom_linerange(size = 0.5, position = position_dodge(width = 0.5), show.legend = FALSE) +
    geom_point(size = 2, position = position_dodge(width = 0.5)) +
    geom_vline(xintercept = c(4.5, 5.5, 6.5), lty = 3, colour = "grey40") +
    scale_fill_manual(values = c("black", "red"), guide = guide_legend(reverse = TRUE), name = "") +
    scale_color_manual(values = c("black", "red"), guide = guide_legend(reverse = TRUE), name = "") +
    scale_x_discrete(limits = rev) +
    scale_y_continuous(breaks = c(-20, -15, -10, -5, 0, 5, 10, 15, 20)) +
    labs(x = "", y = "Marginal effect (difference in probability of religiosity outcome; %-point)") +
    coord_flip() +
    theme_bw() +
    theme(axis.title = element_text(size = 14), axis.text = element_text(size = 12),
          legend.text = element_text(size = 12), panel.grid.minor = element_blank()))


# Save this plot
pdf("./marginalResults_RQ1.pdf", height = 5, width = 10)
plot
dev.off()



##### And repeat for RQ2 marginal effects

# Read in results
res <- read_csv("marginal_RQ2.csv")
head(res)


# Process some variables
res <- res %>%
  mutate(contrast = factor(contrast, levels = c("Belief - Not sure vs No",
                                                "Belief - Yes vs No",
                                                "Identity - Religious vs None",
                                                "Attend - Regular vs Never/Occasional",
                                                "LCA - 'Agnostic' vs 'Atheist'", 
                                                "LCA - 'Moderately religious' vs 'Atheist'",
                                                "LCA - 'Highly religious' vs 'Atheist'"))) %>%
  mutate(model = factor(model, levels = c("CCA", "MI")))
res


# Make the plot
(plot <- ggplot(res, aes(x = contrast, y = est, ymin = lci, ymax = uci, col = model, fill = model)) +
    geom_hline(yintercept = 0, lty = 2) +
    geom_linerange(size = 0.5, position = position_dodge(width = 0.5), show.legend = FALSE) +
    geom_point(size = 2, position = position_dodge(width = 0.5)) +
    geom_vline(xintercept = c(3.5, 4.5, 5.5), lty = 3, colour = "grey40") +
    scale_fill_manual(values = c("black", "red"), guide = guide_legend(reverse = TRUE), name = "") +
    scale_color_manual(values = c("black", "red"), guide = guide_legend(reverse = TRUE), name = "") +
    scale_x_discrete(limits = rev) +
    scale_y_continuous(breaks = c(-10, -5, 0, 5, 10, 15, 20, 25)) +
    labs(x = "", y = "Marginal effect (difference in probability of PE; %-point)") +
    coord_flip() +
    theme_bw() +
    theme(axis.title = element_text(size = 14), axis.text = element_text(size = 12),
          legend.text = element_text(size = 12), panel.grid.minor = element_blank()))


# Save this plot
pdf("./marginalResults_RQ2.pdf", height = 5, width = 10)
plot
dev.off()
