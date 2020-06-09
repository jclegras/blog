+++
author = "Jean-Charles Legras"
title =  "Jointure de JSON avec Python et pandas"
date = "2020-06-04"
draft = false
tags = ["pandas", "python", "json"]
+++

## Merge d'objets JSON avec Python et Pandas

#### Besoin

Nous avons une API avec quelques paths comme :

```
/list/modules # liste tous les modules
/list/teams # liste toutes les équipes par pays
/details/{module_id} # description d'un module en particulier
```

Nous souhaitons obtenir la description complète de chaque module retourné par la liste des modules (premier path).

Nous voulons réduire au maximum le nombre d'appels réseau.

#### Solution classique

En multipliant les appels réseau, nous pouvons appliquer l'algorithme suivant :

```
modules := data(/list/modules)
Pour chaque module dans modules:
  afficher(data(/details/module.id))
```

#### Solution avec jointure des listes JSON

```
modules := data(/list/modules)
teams := data(/list/teams)
afficher(jointure_gauche(modules, teams))
```

On réduit ici le nombre d'appels réseau même si dans les deux cas, une pagination est toujours faisable, puis on fusionne les deux listes obtenues.
Bien sûr, la fusion est possible ici puisqu'on imagine que les deux listes partagent une clé, une colonne commune, de même nom ou non.

#### Solution avec Python et Pandas

**modules.json**
{{< highlight json >}}
{
  "results": [
    {
      "id": 1,
      "module": "docker"
    },
    {
      "id": 2,
      "module": "kubernetes"
    },
    {
      "id": 3,
      "module": "nodeJS"
    }
  ]
}
{{< /highlight >}}

**teams.json**
{{< highlight json >}}
{
  "results": [
    {
      "id": 1,
      "team": "DevOps",
      "countryCode": "FR"
    },
    {
      "id": 2,
      "team": "DevOps",
      "countryCode": "FR"
    },
    {
      "id": 3,
      "team": "B2C",
      "countryCode": "UK"
    }
  ]
}
{{< /highlight >}}

**main.py**
{{< highlight python >}}
import json
import pandas as pd

df1 = None
df2 = None
with open('./modules.json') as json_file:
    data = json.load(json_file)
    df1 = pd.json_normalize(data, "results")
with open('./teams.json') as json_file:
    data = json.load(json_file)
    df2 = pd.json_normalize(data, "results")

df1AndDf2 = df1.merge(df2, how="left", on="id")

print(df1AndDf2.to_json(orient="records"))
{{< /highlight >}}

**Résultat**

{{< highlight json >}}
[
  {
    "id": 1,
    "module": "docker",
    "team": "DevOps",
    "countryCode": "FR"
  },
  {
    "id": 2,
    "module": "kubernetes",
    "team": "DevOps",
    "countryCode": "FR"
  },
  {
    "id": 3,
    "module": "nodeJS",
    "team": "B2C",
    "countryCode": "UK"
  }
]
{{< /highlight >}}

## Résumé

C'est un exemple inutile mais il permet de voir comment on peut fusionner deux listes json, objet par objet, en fonction d'un pivot, d'une clé.
Nous ne sommes pas contraints aux left joins, Pandas permet plusieurs types de jointures calquées sur le modèle SQL.

Pandas est un outil très puissant qui permet bien d'autres choses.
En effet, ce dernier a pour but d'être le bloc de construction fondamental de haut-niveau pour faire de l'analyse de données réaliste ancrée dans le monde réel, [rien que ça](https://pandas.pydata.org/about/index.html).

En bref, ses créateurs/contributeurs veulent en faire l'outil open source le plus puissant et flexible de tous les langages concernant le domaine de l'analyse/manipulation de données.

## Ressources

* [Pandas](https://pandas.pydata.org/)
* [Merge de data frames](https://pandas.pydata.org/docs/getting_started/intro_tutorials/08_combine_dataframes.html)
* [Jointures supportées](https://pandas.pydata.org/docs/user_guide/merging.html#merging-join)
* [Comparaison avec SQL](https://pandas.pydata.org/docs/getting_started/comparison/comparison_with_sql.html#compare-with-sql-join)
