output_folder <- "C:/Users/thele/OneDrive/Desktop/R_assigments/"
setwd(output_folder)

file_path <- paste0(output_folder, "PRSA_Data_Aotizhongxin_20130301-20170228.csv")

import_dataset <- function(path) {
  tryCatch({
    data <- read.csv(path, stringsAsFactors = FALSE)
    cat("File imported successfully.\n")
    return(data)
  },
  error = function(e) {
    if (!file.exists(path)) {
      cat("ERROR: File not found at path:", path, "\n")
    } else {
      cat("ERROR: File could not be read. Details:", conditionMessage(e), "\n")
    }
    return(NULL)
  },
  warning = function(w) {
    cat("WARNING while reading file:", conditionMessage(w), "\n")
  })
}

air_data <- import_dataset(file_path)

if (!is.null(air_data)) {
  cat("\n--- First six records ---\n")
  print(head(air_data))

  cat("\n--- Structure of dataset ---\n")
  str(air_data)

  cat("\n--- Dimensions ---\n")
  cat("Rows:", nrow(air_data), " Columns:", ncol(air_data), "\n")

  cat("\n--- Any missing values present? ---\n")
  print(any(is.na(air_data)))

  cat("\n--- Total number of missing values ---\n")
  print(sum(is.na(air_data)))
} else {
  stop("Dataset could not be loaded. Please check the file path.")
}

cat("\n============================================================\n")
cat("TASK 2: NA vs NULL vs NaN\n")
cat("============================================================\n")

temperature <- c(28, 30, NA, 32)
cat("\nExample of NA:\n")
print(temperature)
cat("is.na():", is.na(temperature), "\n")

missing_object <- NULL
cat("\nExample of NULL:\n")
print(missing_object)
cat("is.null():", is.null(missing_object), "\n")

undefined_value <- 0 / 0
cat("\nExample of NaN:\n")
print(undefined_value)
cat("is.nan():", is.nan(undefined_value), "\n")

cat("\nNote: is.na(NaN) returns:", is.na(undefined_value), "\n")
cat("But is.nan(NA) returns:", is.nan(NA), "\n")

cat("\n============================================================\n")
cat("TASK 3: Missing Value Summary\n")
cat("============================================================\n")

missing_summary <- function(df) {
  if (!is.data.frame(df)) {
    stop("Input must be a data frame.")
  }

  var_names <- names(df)
  total_records <- nrow(df)
  missing_values <- sapply(df, function(x) sum(is.na(x)))
  missing_percentage <- round((missing_values / total_records) * 100, 2)

  summary_df <- data.frame(
    Variable = var_names,
    Total_Records = total_records,
    Missing_Values = missing_values,
    Missing_Percentage = missing_percentage,
    row.names = NULL
  )

  high_missing <- summary_df[summary_df$Missing_Percentage > 20, "Variable"]
  if (length(high_missing) > 0) {
    warning(paste("The following variables have more than 20% missing values:",
                   paste(high_missing, collapse = ", ")))
  }

  return(summary_df)
}

selected_vars <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM", "wd")
selected_vars <- selected_vars[selected_vars %in% names(air_data)]

summary_result <- missing_summary(air_data[selected_vars])
cat("\nMissing Value Summary:\n")
print(summary_result)

write.csv(summary_result, paste0(output_folder, "missing_value_summary.csv"), row.names = FALSE)
cat("Missing value summary saved as 'missing_value_summary.csv'\n")

cat("\n============================================================\n")
cat("TASK 4: Invalid Numerical Results (pollution_ratio)\n")
cat("============================================================\n")

air_data$pollution_ratio <- air_data$PM2.5 / air_data$PM10

cat("Number of NA in pollution_ratio:", sum(is.na(air_data$pollution_ratio)), "\n")
cat("Number of NaN in pollution_ratio:", sum(is.nan(air_data$pollution_ratio)), "\n")
cat("Number of Positive Infinity:", sum(air_data$pollution_ratio == Inf, na.rm = TRUE), "\n")
cat("Number of Negative Infinity:", sum(air_data$pollution_ratio == -Inf, na.rm = TRUE), "\n")

air_data$pollution_ratio[is.nan(air_data$pollution_ratio)] <- NA
air_data$pollution_ratio[is.infinite(air_data$pollution_ratio)] <- NA

cat("After cleaning, remaining invalid values:",
    sum(is.nan(air_data$pollution_ratio)) + sum(is.infinite(air_data$pollution_ratio), na.rm = TRUE), "\n")

cat("\n============================================================\n")
cat("TASK 5: Loop-based Numerical Missing Value Treatment\n")
cat("============================================================\n")

numeric_variables <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM")

missing_before <- c()
missing_after <- c()

for (var in numeric_variables) {

  if (!(var %in% names(air_data))) {
    cat("Column", var, "does not exist. Skipping.\n")
    next
  }

  before_count <- sum(is.na(air_data[[var]]))
  med_value <- median(air_data[[var]], na.rm = TRUE)
  air_data[[var]][is.na(air_data[[var]])] <- med_value
  after_count <- sum(is.na(air_data[[var]]))

  missing_before[var] <- before_count
  missing_after[var] <- after_count

  cat("\nVariable:", var, "\n")
  cat("  Missing before treatment:", before_count, "\n")
  cat("  Median used for replacement:", round(med_value, 3), "\n")
  cat("  Missing after treatment:", after_count, "\n")
}

cat("\n============================================================\n")
cat("TASK 6: Categorical Missing Value Treatment (wd)\n")
cat("============================================================\n")

calculate_mode <- function(x) {
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA)
  freq_table <- table(x)
  mode_value <- names(freq_table)[which.max(freq_table)]
  return(mode_value)
}

wd_before <- sum(is.na(air_data$wd))
wd_mode <- calculate_mode(air_data$wd)
air_data$wd[is.na(air_data$wd)] <- wd_mode
wd_after <- sum(is.na(air_data$wd))

missing_before["wd"] <- wd_before
missing_after["wd"] <- wd_after

cat("Mode of wd:", wd_mode, "\n")
cat("Missing before replacement:", wd_before, "\n")
cat("Missing after replacement:", wd_after, "\n")

cat("\n============================================================\n")
cat("TASK 7: Reusable clean_variable() with Error Handling\n")
cat("============================================================\n")

clean_variable <- function(df, var_name) {
  tryCatch({

    if (!(var_name %in% names(df))) {
      stop(paste("Variable", var_name, "does not exist in the dataset."))
    }

    variable <- df[[var_name]]

    if (!is.numeric(variable)) {
      stop(paste("Variable", var_name, "is categorical, not numerical."))
    }

    if (all(is.na(variable))) {
      stop(paste("Variable", var_name, "contains only missing values."))
    }

    med_value <- median(variable, na.rm = TRUE)

    if (is.na(med_value)) {
      stop(paste("Median could not be calculated for", var_name))
    }

    variable[is.na(variable)] <- med_value
    cat("Variable", var_name, "cleaned successfully. Median used:", round(med_value, 3), "\n")
    return(variable)

  }, error = function(e) {
    cat("Could not clean variable '", var_name, "': ", conditionMessage(e), "\n", sep = "")
    return(NULL)
  })
}

test1 <- clean_variable(air_data, "SO2")
test2 <- clean_variable(air_data, "wd")
test3 <- clean_variable(air_data, "NonExistentCol")

cat("\n============================================================\n")
cat("TASK 8: Before vs After Comparison Table\n")
cat("============================================================\n")

comparison_table <- data.frame(
  Variable = names(missing_before),
  Missing_Before = as.numeric(missing_before),
  Missing_After = as.numeric(missing_after),
  Values_Replaced = as.numeric(missing_before) - as.numeric(missing_after)
)

print(comparison_table)

write.csv(comparison_table, paste0(output_folder, "comparison_before_after.csv"), row.names = FALSE)
cat("Comparison table saved as 'comparison_before_after.csv'\n")

cat("\nInterpretation: All selected variables show Missing_After = 0,",
    "confirming that median imputation (numerical) and mode imputation",
    "(categorical) successfully removed all missing values in the",
    "selected columns.\n")

cat("\n============================================================\n")
cat("TASK 9: Missing Value Visualization\n")
cat("============================================================\n")

png(paste0(output_folder, "missing_values_comparison.png"), width = 800, height = 500)

bar_matrix <- t(as.matrix(comparison_table[, c("Missing_Before", "Missing_After")]))
colnames(bar_matrix) <- comparison_table$Variable

barplot(bar_matrix,
        beside = TRUE,
        col = c("firebrick", "forestgreen"),
        main = "Missing Values Before vs After Cleaning",
        xlab = "Variables",
        ylab = "Number of Missing Values",
        legend.text = c("Before Cleaning", "After Cleaning"),
        args.legend = list(x = "topright"))

dev.off()
cat("Bar chart saved as 'missing_values_comparison.png'\n")

cat("\n============================================================\n")
cat("TASK 10: Export Cleaned Dataset\n")
cat("============================================================\n")

write.csv(air_data, paste0(output_folder, "cleaned_air_quality_data.csv"), row.names = FALSE)
cat("Cleaned dataset exported as 'cleaned_air_quality_data.csv'\n")

cat("\n====================== SCRIPT COMPLETE ======================\n")