library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)
 res = GET("https://brasil.io/api/dataset/covid19/caso_full/data/?search=&date=&state=&city=S%C3%A3o+Paulo&place_type=&is_last=&city_ibge_code=&order_for_place=")
res

data = fromJSON(rawToChar(res$content))



dados_sp = data[["results"]]

dados_sp_selecionada = dados_sp %>% select(c("date", "last_available_confirmed", "last_available_deaths", "order_for_place"))

colnames(dados_sp_selecionada) = c("Data", "Confirmações de casos", "Confirmações de óbitos", "Dia de contagem")

dados_sp_selecionada_long = pivot_longer(dados_sp_selecionada, 
                                         cols = c("Confirmações de casos", "Confirmações de óbitos"),
                                         names_to = "Tipo",
                                         values_to = "Contagem")

ultima_data = dados_sp_selecionada_long[["Data"]][1]

library(ggplot2)
library(plotly)

x_label = paste0('Contagem', " (até ", ultima_data, ")")

p1 = ggplot(dados_sp_selecionada_long, aes(x=`Dia de contagem`,    y = Contagem,      color = Tipo))    + 
  geom_point(size=2) + 
  ggtitle ("Confirmações cumulativas de COVID-19 na cidade de São Paulo")+
  xlab(x_label)+ 
  labs(caption = "Fonte: Dados consolidados por Brasil IO a partir dos boletins da prefeitura ")

ggplotly(p1)

diff(dados_sp_selecionada[,"Confirmações de casos"])

