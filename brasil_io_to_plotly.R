library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)

# res = GET("https://brasil.io/api/dataset/covid19/caso_full/data/?search=&date=&state=&city=S%C3%A3o+Paulo&place_type=&is_last=&city_ibge_code=&order_for_place=")
#write.csv(dados_sp, "dados_sp_hj.csv")



data = fromJSON(rawToChar(res$content))
dados_sp = data[["results"]]


test = read.csv("dados_sp_hj.csv")
dados_sp_selecionada = dados_sp %>% select(c("date", "last_available_confirmed", "last_available_deaths", "order_for_place"))

colnames(dados_sp_selecionada) = c("Data", "Confirmações de casos", "Confirmações de óbitos", "Dia de contagem")
library(ggplot2)
library(plotly)


dados_sp_selecionada["Casos por dia"] <- c(-(diff(dados_sp_selecionada[,"Confirmações de casos"])),0)
dados_sp_selecionada["Óbitos por dia"] <- c(-(diff(dados_sp_selecionada[,"Confirmações de óbitos"])),0)

dados_sp_selecionada_long = pivot_longer(dados_sp_selecionada, 
                                         cols = c("Confirmações de casos", "Confirmações de óbitos", "Casos por dia", "Óbitos por dia"),
                                         names_to = "Tipo",
                                         values_to = "Contagem")


ultima_data = dados_sp_selecionada_long[["Data"]][1]
x_label = paste0('Contagem', " (até ", ultima_data, ")")


so_casos <- dados_sp_selecionada_long %>% filter(`Tipo` %in% c("Confirmações de casos", "Casos por dia"))

p1 = ggplot(so_casos, aes(x=`Dia de contagem`,    y = Contagem,      color = Tipo))    + 
  geom_line(size=2) + 
  ggtitle ("Casos confirmados de COVID-19 na cidade de São Paulo")+
  xlab(x_label)+ 
  labs(caption = "Fonte: Dados consolidados por Brasil IO a partir dos boletins da prefeitura ")

ggsave(p1, filename = "casos.png", device = "png")


so_casos_diarios <- dados_sp_selecionada_long %>% filter(`Tipo` %in% c("Casos por dia"))
p3 = ggplot(so_casos_diarios, aes(x=`Dia de contagem`,    y = Contagem,      color = Tipo))    + 
  geom_line(size=2) + 
  ggtitle ("Casos confirmados de COVID-19 na cidade de São Paulo")+
  xlab(x_label)+ 
  labs(caption = "Fonte: Dados consolidados por Brasil IO a partir dos boletins da prefeitura ")

ggsave(p3, filename = "casos_por_dia.png", device = "png")





so_obitos <- dados_sp_selecionada_long %>% filter(`Tipo` %in% c("Confirmações de óbitos", "Óbitos por dia"))

p2 = ggplot(so_obitos, aes(x=`Dia de contagem`,    y = Contagem,      color = Tipo))    + 
  geom_line(size=2) + 
  ggtitle ("Óbitos confirmados de COVID-19 na cidade de São Paulo")+
  xlab(x_label)+ 
  labs(caption = "Fonte: Dados consolidados por Brasil IO a partir dos boletins da prefeitura ")

ggsave(p2, filename = "obitos_por_dia.png", device = "png")


so_obitos_diarios <- dados_sp_selecionada_long %>% filter(`Tipo` %in% c("Óbitos por dia"))
p4 = ggplot(so_obitos_diarios, aes(x=`Dia de contagem`,    y = Contagem,      color = Tipo))    + 
  geom_line(size=2) + 
  ggtitle ("Óbitos confirmados de COVID-19 na cidade de São Paulo")+
  xlab(x_label)+ 
  labs(caption = "Fonte: Dados consolidados por Brasil IO a partir dos boletins da prefeitura ")

ggsave(p4, filename = "obitos_por_dia.png", device = "png")

