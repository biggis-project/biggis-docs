!!! note "Responsible person for this section"
    - Hannes Müller (LUBW)
    - Johannes Kutterer (Disy)
    - Daniel Seebacher (Uni Konstanz)

# Invasive species

## Motiviation

Invasive species are a major cause of ecological damage and commercial losses. A current problem spreading in North America and Europe is the vinegar fly Drosophila suzukii. Unlike other Drosophila, it infests non-rotting and healthy fruits and is therefore of concern to fruit growers, such as vintners.  Consequently, large amounts of data about the occurrence of D. suzukii have been collected in recent years. However, there is a lack of interactive methods to investigate this data. 

## Used Data Sources

- ATKIS/ALKIS
- Vitimeteo
- ASTER Elevation Map

## Data Description

In the data provided by VitiMeteo are, among other things, observations of the spread of D. suzukii. This data consists of trap findings of D. suzukii as well as percentage information about how many berries were infested in a sample taken at the station. Additionally, there is percentage information about how many eggs were found in a sample. This percentage can be over 100 %, if there are more egg findings than berries in a sample. These observations are collected from 867 stations non-uniformly spread over Baden-Wuerttemberg. Some of them only report observations for one day, others report multiple observations over a time period of up to 1641 days. The observations are rather sparse and irregularly sampled, which makes the use of standard time series analysis techniques challenging, if not impossible. Consequently, an interactive visual analysis should enable researchers to interactively analyze this complex data source. 

## Prediction of Infested Areas

We enriched the data provided by VitiMeteo, by adding information about the environmental surroundings of each station. First, we added the height information, which we extracted from ASTER. Second, we added the surrounding land usage information. Since a local spread is possible by D. suzukii itself, we extracted the land usage information in a 5~km radius around each station. Finally, we have an 85 dimensional feature vector for each instance, consisting of the month of the year, the station height, and the surrounding land usage.

We end up with a rather imbalanced data set with four times as many negative examples as positive ones. This can cause problems since many machine learning algorithms depend on the assumption that the given data set is balanced. Although machine learning techniques exist which can deal with imbalanced data sets, such as the Robust Decision Trees, we want to employ ensemble-based classification, which is a combination of different classifiers. This allows us to improve the classification performance and also to model the uncertainty of our classification, which aids people in making more informed decisions. This requires the creation of a balanced data set, which we can achieve by either using undersampling of the majority class or oversampling of the minority class. Undersampling can be achieved by stratified sampling using the occurrence class as strata. However, this would remove instances from our already small data set. To avoid this, we employ oversampling of the minority class using the Synthetic Minority Over-sampling Technique (SMOTE). SMOTE picks pairs of nearest neighbors in the minority class and creates artificial instances by randomly placing a point on the line between the nearest neighbors until the data is balanced. Thus, allowing us to employ default machine learning algorithms. 

## Hypothesenentwicklung
Hypothesenentwicklung zur Vermehrung der KEF aufgrund biologischer Erkenntnisse
(v.a. abhängig von Umgebungstemperatur und Vegetation)

## Entwicklung einer Vektordatenpipeline in BigGIS
- Datenquelle [www.vitimeteo.de](http://www.vitimeteo.de)
- Datensammlung (kafka)
- Prozessierung (flink)
- Visualisierung (Uni-Konstanz)

## Drosophigator Prototype for the Visual Analysis of Spatio-Temporal Event Predictions

- Investigating the Spread Dynamics of invasive species
- VDS and now journal extension
- Ensemble-Based Classification of Infested Areas
- Visual Analysis 
- Demonstration and Evaluation at the 6th workshop of the working group D Suzukii in Bad Kreuznach

## Results
- Häufiges Auftreten der KEF
  - Nähe zu Wald -> Refugium für Kirschessigfliege zum Überleben bei widrigen Wetterbedingungen

## Related Scenarios
- [Environment](../scenarios/03_env.md)
