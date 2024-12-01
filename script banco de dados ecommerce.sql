-- criaçaõ de banco de dados do cenário ecommerce
create database ecommerce;
use ecommerce;

-- principais tabelas:

create table clientes(
id_cliente int not null auto_increment primary key,
nome varchar (15) not null,
nome_do_meio varchar (3) not null,
sobrenome varchar (15) not null,
estado varchar (15) not null,
cidade varchar (25) not null,
bairro varchar (25) not null,
rua varchar (25) not null,
casa_apt varchar (25) not null,
numero varchar(17) DEFAULT ('nao informado'),
data_nascimento date
);

create table pagamento(
id_pagamento int not null auto_increment primary key,
id_cliente int not null,
forma_pagamento ENUM('Dinheiro', 'Pix', 'Boleto', 'Cartao de credito', 'Cartao de debito') NOT NULL,
dados_cartao VARCHAR(45) NOT NULL DEFAULT ('nao informado'),
banco VARCHAR(20) NOT NULL DEFAULT ('nao informado'),
agencia_opcional Varchar (17) NOT NULL DEFAULT ('nao informado'), -- em caso de estorno 
numero_da_conta_opicional Varchar(25) NOT NULL DEFAULT ('nao informado'), -- em caso de estorno
foreign key (id_cliente) references clientes(id_cliente)
);

create table pedidos(
id_pedido int not null auto_increment primary key,
id_cliente int not null,
status_pedido ENUM ('Em andamento', 'Processando', 'Enviado', 'Cancelado'),
descricao varchar (60),
valor decimal not null,
frete float,
id_pagamento int not null,
foreign key (id_cliente) references clientes(id_cliente),
foreign key (id_pagamento) references pagamento(id_pagamento)
);

CREATE TABLE entrega(
id_entrega INT NOT NULL primary key auto_increment,
id_pedido INT NOT NULL,
Status_entrega ENUM ('Ainda não enviado', 'Enviado', 'Recebido'),
Codigo_rastreio VARCHAR(200) NOT NULL,
Previsão_chegada varchar (18) DEFAULT ('Indefinido'),
FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

create table produtos(
id_produto int not null auto_increment primary key,
categoria varchar (45) not null DEFAULT ('nao informado'),
marca varchar (25) not null,
prod_nome varchar (45) not null,
valor decimal not null
);

CREATE TABLE conta(
id_conta INT NOT NULL auto_increment primary key,
id_cliente INT NOT NULL,
usuario VARCHAR(45) NOT NULL,
email VARCHAR(45) NOT NULL,
CPF CHAR (16) NOT NULL default ('não informado'), -- sem traços e pontos 
CNPJ CHAR (16) NOT NULL default ('não informado'), -- sem traços e pontos 
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE estoque(
id_estoque INT NOT NULL auto_increment primary key,
endereco VARCHAR(200) NOT NULL
);

CREATE TABLE fornecedor(
id_fornecedor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
razão_social VARCHAR(45) NOT NULL,
CNPJ CHAR(15) NOT NULL UNIQUE,
contato CHAR(11) NOT NULL -- apenas números
);

CREATE TABLE atendentes(
id_atendentes INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nome_atendente varchar (70) not null,
CPF_CNPJ CHAR(15) NOT NULL UNIQUE,
contato CHAR(11) NOT NULL -- apenas números
);
  

-- tabelas geradas a partir do relacionamento n:m entre as tabelas principais:

  CREATE TABLE atendentes_clientes (
id_cliente INT NOT NULL,
id_conta INT NOT NULL,
id_atendentes INT NOT NULL,
PRIMARY KEY (id_cliente, id_conta, id_atendentes)
);

Alter table atendentes_clientes
Add constraint fk_co_id_cliente FOREIGN KEY (id_cliente) REFERENCES conta(id_cliente),
Add constraint fk_co_id_conta FOREIGN KEY (id_conta) REFERENCES conta(id_conta),
Add constraint fk_vd_id_atendentes FOREIGN KEY (id_atendentes) REFERENCES atendentes(id_atendentes);


 CREATE TABLE produto_por_fornecedor(
id_produto INT NOT NULL,
id_fornecedor INT NOT NULL,
Qtd_produto BIGINT NULL DEFAULT 0,
PRIMARY KEY (id_produto, id_fornecedor),
CONSTRAINT fk_p_produtos FOREIGN KEY (id_produto) REFERENCES produtos(id_produto),
CONSTRAINT fk_p_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

CREATE TABLE produto_por_estoque(
id_produto INT NOT NULL,
id_estoque INT NOT NULL,
Qtd_produto_por_estoque BIGINT NULL DEFAULT 0,
PRIMARY KEY (id_produto, id_estoque),
CONSTRAINT fk_pr_produtos FOREIGN KEY (id_produto) REFERENCES produtos(id_produto),
CONSTRAINT fk_pr_estoque FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque)
);

CREATE TABLE produto_por_pedido(
id_produto INT NOT NULL,
id_pedido INT NOT NULL,
Qtd_produto_pedido BIGINT NOT NULL DEFAULT 1,
PRIMARY KEY (id_produto, id_pedido),
FOREIGN KEY (id_produto) REFERENCES produtos(id_produto),
FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- inserção de dados às tabelas

Insert into clientes (nome, nome_do_meio, sobrenome, estado, cidade, bairro, rua, casa_apt, numero, data_nascimento)
Values 
	('Myrella', 'G', 'Silva', 'PE', 'Paulista', 'Centro', 'Av.calha', 'Casa', 09, '2002-04-19'),
	('Gabriel', 'H', 'Moura', 'PE', 'Recife', 'Aflitos', 'Av.rosa', 'Apartamento', 101, '2000-09-28'),
    ('Thiago', 'A', 'Alves', 'GO', 'Inop', 'Arruda', 'Belas flores', 'Casa', 11, '1985-04-08'),
    ('Emellyn', 'V', 'Freire', 'BA', 'Salvador', 'Caixias', 'Rua magna', 'Apartamento', 08, '1997-08-25'),
    ('Victoria', 'M', 'Lima', 'SP', 'Joinville', 'Ahai', 'Av. Costa', 'Casa', 04, '2001-01-28');
    
Insert into produtos (categoria, marca, prod_nome, valor)
Values 
	('Cosmeticos', 'BY Beauty', 'Batom', 35),
    ('Cosmeticos', 'NOVA', 'Blush', 15.99),
    ('Eletronicos', 'ELPPA', 'Smarthphone', 2999),
    ('Vestuario', 'CK Roupas', 'Calça', 70.00),
    ('Vestuario', 'CK Roupas', 'Camiseta', 50.00),
    ('Eletronicos', 'ELPPA', 'Notebook', 4000);
    
Insert into pagamento (id_cliente, forma_pagamento, dados_cartao, banco, agencia_opcional, numero_da_conta_opicional)
Values 
	(1, 'Cartão de Credito', 2345-3535-2487-1387, 'BB', default, default),
    (2, 'Cartão de Credito', 7890-3535-1234-0987, 'UN', default, default),
    (3, 'PIX', Default, Default, default, default),
    (4, 'Cartão de Debito', 7654-2323-4628-8562, 'BR', default, default),
    (5, 'Boleto',  Default, Default, default, default),
    (1, 'Cartão de Debito', 6573-3424-9137-4626, 'CP', default, default);
    
Insert into pedidos (id_cliente, status_pedido, descricao, valor, frete, id_pagamento)
Values
	(1, 'Processando', 'Batom e Notebook', 4035, 150, 1), 
    (2, 'Enviado', 'Blush', 16, 150, 2),
    (2, 'Enviado', 'Notebook', 4000, 150, 2),
    (3, 'Processando', 'Camiseta e Calça', 120, 300, 3),
    (4, 'Processando', 'Batom e Blush', 51, 170, 4),
    (4, 'Enviado', 'Smarthphone e Blush', 3015, 170, 4),
    (5, 'Processando', 'Calça e Blush', 86, 200, 5);
    
Insert into fornecedor (razão_social, CNPJ, contato) 
Values
	('BY Beauty LTDA', 723456789101234, 81996759898),
    ('NOVA LTDA', 987654321109283, 8198786556),
    ('ELPPA LTDA', 547897102789, 71996759898),
    ('CK Clothes LTDA', 123456789101214, 51974568923);
    
Insert into conta (id_cliente, usuario, email, CPF, CNPJ)
Values
	(1, 'myrellasilva', 'myrellasilva@gmail.com', 98778998778, default),
    (2, 'lagostagh', 'gabrielhgomes@gmail.com', 12345678910, default),
    (3, 'andrezot', 'thiagrodrezo@gmail.com', default, 347364284798493),
    (4, 'emellyn_f', 'emellynfreire@gmail.com', 12348759843, default),
    (5, 'victoriamay', 'vicmay@gmail.com', default, 438579765234586);
    
Insert into entrega (id_pedido, Status_entrega, Codigo_rastreio, Previsão_chegada)
Values
	(1, 'Ainda não enviado', 'AMCDF73849143SF4F', default),
	(2, 'Enviado', 'DFG4Y4UHD44WGEGA5F', '2024-12-12'),
	(3, 'Enviado', 'FMHFQIHFRR7914F', '2024-11-30'),
	(4, 'Ainda não enviado', 'DNR29EYFHFCEFEFGEG', default),
	(5, 'Ainda não enviado', 'DNDUHFWIGH74GHR29', default),
	(6, 'Enviado', 'AMFEHFFGG46GCDF7384914F', '2024-12-24'),
	(7, 'Ainda não enviado', 'AMCDFWEFWF7384914F', default);

Insert into estoque (endereco)
Values 
	('Av. borges, Recife, Pernambuco, 53645.619');

Insert into produto_por_estoque (id_produto, id_estoque, Qtd_produto_por_estoque)
Values 
	(1, 1, 200),
	(2, 1, 150),
	(3, 1, 200),
	(4, 1, 150),
	(5, 1, 300),
	(6, 1, 200);

Insert into produto_por_fornecedor (id_produto, id_fornecedor, Qtd_produto)
Values 
	(1, 1, 200),
	(2, 2, 150),
	(3, 3, 200),
	(4, 4, 150),
	(5, 4, 300),
	(6, 3, 200);
    
Insert into produto_por_pedido (id_produto, id_pedido, Qtd_produto_pedido)
Values
	(1, 1, 1),
	(2, 1, 1),
	(2, 2, 1),
	(6, 3, 1),
	(5, 4, 1),
	(4, 4, 1),
	(1, 5, 1),
	(2, 5, 1),
	(3, 6, 1),
	(2, 6, 1),
	(4, 7, 1),
	(2, 7, 1);
    
Insert into atendentes (nome_atendente, CPF_CNPJ, contato)
Values
	('João Campos', 98767854614, 91996387997), 
    ('Julia Mota Barros', 67598723415, 89986751433),
    ('Marcos Paz Saraiva', 06789870526, 71946541427);

INSERT INTO atendentes_clientes (id_cliente, id_conta, id_vendedores)
VALUES
	();
    
-- QUERIES
-- Quantos pedidos foram feitos por cada cliente e qual cliente mais gastou?

    Select 
		p.id_cliente,
        concat(nome, ' ', nome_do_meio, ' ', sobrenome) as NOME_COMPLETO,
        count(valor) as QTD_Pedidos,
        sum(valor) as TOTAL_por_Cliente
	From clientes c 
    Join pedidos p On c.id_cliente = p.id_cliente
    Group by p.id_cliente
    Order by QTD_Pedidos desc;
    
-- Query que retorna o nome completo dos clientes, produtos comprados e valor da compra
Select
	p.id_cliente,
    p.id_pedido,
	concat(nome, ' ', nome_do_meio, ' ', sobrenome) as 'NOME COMPLETO',
    descricao as 'Produtos comprados',
    valor as 'Valor da Compra'
From pedidos p
Join clientes c on p.id_cliente = c.id_cliente;

 -- query que retorna a razão social dos fornecedores e os produtos comercializados
 
 select 
	id_fornecedor,
	razão_social,
    categoria,
    prod_nome
from fornecedor f
join produtos p on p.id_produto = f.id_fornecedor;

-- query que retorna a razão social dos fornecedores e os produtos comercializados na categoria cosmeticos e eletronicos

 select 
	id_fornecedor,
	razão_social,
    categoria,
    prod_nome
from fornecedor f
join produtos p on p.id_produto = f.id_fornecedor
where categoria in ('cosmeticos','eletronicos');
