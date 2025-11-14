### My custom functions

##load data
load_data = function 

# clean data
clean_data = function(raw_traits){
  traits = raw_traits |>
    # remove NAs
    filter(!is.na(Value)) |>
    # order factor and rename variable gradient
    mutate(Gradient = case_match(Gradient,
                                 "C" ~ "Control",
                                 "B" ~ "Nutrients"),
           Gradient = factor(Gradient, levels = c("Control", "Nutrients"))) |>
    # select one species and one trait
    filter(Taxon == "alopecurus magellanicus",
           Trait == "Leaf_Area_cm2")
}

# run a linear regression
fit_model = function(data, response, predictor){
  mod = lm(as.formula(paste(response, "~", predictor)), data = data)
  mod
}

# make figure
make_figure = function(traits){
  ggplot(traits, aes(x = Gradient, y = Value)) +
    geom_boxplot(fill = c("grey80", "darkgreen")) +
    labs(x = "", y = expression(Leaf~area~cm^2)) +
    theme_bw()
}