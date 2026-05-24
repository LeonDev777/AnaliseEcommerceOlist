# AnaliseEcommerceOlist
Análise de vendas com SQL usando dados de e-commerce brasileiro (Olist)
# Projeto SQL Olist 

Esse projeto foi feito pra praticar os meus conhecimentos de SQL usando os dados públicos do e-commerce da Olist. Como estou estudando faz 8 meses, queria testar como fazer queries que respondem perguntas que o pessoal de negócios pede no dia a dia.

### O que o projeto responde:
1. O faturamento mensal e os gastos com frete.
2. Quais estados geram mais receita e o ticket médio de cada um.
3. As categorias de produtos mais vendidas.
4. Se existem clientes recorrentes que compraram mais de uma vez.

### Como rodar
Os scripts foram feitos pensando no SQLite ou banco compatível. 
1. Rode primeiro o `create_tables.sql` para criar a estrutura.
2. Depois o `seed_data.sql` para colocar alguns dados de teste que eu mesmo criei.
3. Depois dá pra rodar qualquer um dos arquivos de query para ver os resultados.

### O que aprendi fazendo
* Consegui entender melhor como o JOIN funciona quando precisa juntar mais de 3 tabelas seguidas sem se perder nos IDs.
* Aprendi a usar a cláusula HAVING junto com o GROUP BY para filtrar contagens específicas (usei isso para achar os clientes fiéis).
* Quebrei a cabeça um pouco com funções de data para formatar o mês, mas deu certo.

