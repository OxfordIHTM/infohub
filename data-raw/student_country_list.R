# Create a student-country list by year ----------------------------------------

cohort <- c(
  rep("Class 2015-2016", 18),
  rep("Class 2016-2017", 16),
  rep("Class 2017-2018", 18),
  rep("Class 2018-2019", 26),
  rep("Class 2019-2020", 23),
  rep("Class 2020-2021", 27),
  rep("Class 2021-2022", 25),
  rep("Class 2022-2023", 23),
  rep("Class 2023-2024", 29),
  rep("Class 2024-2025", 19)
)

country <- c(
  "Australia", "South Africa", "Belgium", "Taiwan", "Nigeria", "Cameroon",
  "United States of America", "Mexico", "Syria", "Nigeria", "Indonesia",
  "Kenya", "Nepal", "South Africa", "Mexico", "Kenya", "Kenya", 
  "Papua New Guinea",
  "Ghana", "Nigeria", "Australia", "Kenya", "South Africa", "Tanzania",
  "Liberia", "Tanzania", "Zimbabwe", "Botswana", "Mexico", "South Africa",
  "Iran", "Cameroon", "China", "Myanmar",
  "Bangladesh", "Nigeria", "Australia", "Brazil", "United States of America",
  "United Kingdom", "Liberia", "China", "Tanzania", "South Africa", "Malawi",
  "Cameroon", "Nepal", "Canada", "Egypt", "South Africa", "Australia",
  "Liberia",
  "Nigeria", "Kyrgyzstan", "Syria", "Australia", "Kenya", "Cameroon", 
  "South Africa", "Ecuador", "Malawi", "Vietnam", "Malaysia", "Nigeria",
  "Timor-Leste", "Bangladesh", "Argentina", "Fiji", "Sudan", "Nigeria",
  "Argentina", "South Africa", "Kenya", "United States of America", "Cambodia",
  "Sierra Leone", "Myanmar", "Morocco",
  "Argentina", "Nigeria", "Australia", "Sierra Leone", "Ghana", 
  "Papua New Guinea", "Eritrea", "Maldives", "Bangladesh", 
  "United States of America", "Zimbabwe", "Bangladesh", "Thailand", "Malaysia", 
  "South Africa", "Nigeria", "Pakistan", "Nigeria", "Seychelles", "Cameroon",
  "Mozambique", "Malawi", "Japan",
  "Nepal", "Nigeria", "Kenya", "United Kingdom", "United States of America",
  "Zimbabwe", "Philippines", "Nigeria", "Russia", "South Africa", "Sierra Leone",
  "Sierra Leone", "Bangladesh", "Sierra Leone", "Vietnam", "Tanzania", 
  "Malaysia", "Nigeria", "Ghana", "United Kingdom", "India", "Bangladesh",
  "Zambia", "United Kingdom", "Zimbabwe", "Belize",
  "Eritrea", "Ghana", "Indonesia", "Nigeria", "Mozambique", "Nigeria",
  "Nigeria", "Kenya", "Cameroon", "Rwanda", "Cameroon", "Sudan", "Saint Lucia",
  "Indonesia", "South Africa", "Kyrgyzstan", "Vietnam", "Cameroon", 
  "South Africa", "Malaysia", "Colombia", "India", "India", "Nepal", "Myanmar",
  "Nepal", "Nigeria", "India", "Sudan", "Philippines", "Burundi", "Sudan",
  "South Africa", "India", "New Zealand", "Kenya", "South Sudan", "Sudan",
  "Malawi", "Malawi", "Kenya", "Uganda", "Bangladesh", "Nigeria", "Myanmar",
  "Indonesia", "India", "Vietnam",
  "Ghana", "Fiji", "Eritrea", "Nigeria", "South Sudan", "India", "Indonesia",
  "Zimbabwe", "Nigeria", "Ghana", "Sudan", "India", "South Africa", "Armenia",
  "Nigeria", "Nigeria", "Philippines", "Kenya", "Uganda", "South Africa",
  "Uganda", "Malawi", "Sierra Leone", "Argentina", 
  "Democratic Republic of Congo", "Argentina", "Syria", "Taiwan", "Peru",
  "Malaysia",
  "Nigeria", "Palestine", "Liberia", "Ghana", "Lesotho", "Egypt", "Indonesia",
  "Sierra Leone", "Zimbabwe", "Mozambique", "Japan", "Sudan", "Vietnam",
  "Kenya", "Indonesia", "Sri Lanka", "Ghana", "South Sudan", "China"
)

student_country <- tibble::tibble(cohort, country) |>
  dplyr::mutate(
    iso3c = countrycode::countrycode(
      sourcevar = country,
      origin = "country.name",
      destination = "iso3c"
    )
  ) |>
  dplyr::left_join(
    y = mapdeck::capitals |>
      dplyr::mutate(
        country = ifelse(country == "Rawanda", "Rwanda", country),
        iso3c = countrycode::countrycode(
          sourcevar = country,
          origin = "country.name",
          destination = "iso3c"
        )
      ) |>
      dplyr::filter(capital != "Charlotte Amalie") |>
      dplyr::select(iso3c, lat, lon), 
    by = "iso3c"
  ) |>
  dplyr::mutate(
    lat = dplyr::case_when(
      iso3c == "TWN" ~ 25.0330,
      iso3c == "MAR" ~ 34.033333,
      iso3c == "SYC" ~ -4.616667,
      iso3c == "JPN" ~ 35.689722,
      iso3c == "SSD" ~ 4.85,
      iso3c == "PSE" ~ 32,
      iso3c == "LKA" ~ 6.934444,
      .default = lat
    ),
    lon = dplyr::case_when(
      iso3c == "TWN" ~ 121.5654,
      iso3c == "MAR" ~ -6.833333,
      iso3c == "SYC" ~ 55.45,
      iso3c == "JPN" ~ 139.692222,
      iso3c == "SSD" ~ 31.6,
      iso3c == "PSE" ~ 35.25,
      iso3c == "LKA" ~ 79.842778,
      .default = lon
    )
  )

write.csv(
  student_country, file = "data-raw/student_country.csv", row.names = FALSE
)

usethis::use_data(student_country, overwrite = TRUE, compress = "xz")
  

