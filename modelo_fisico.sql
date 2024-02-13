-- Exemplo de modelo físico para a situação apresentada

CREATE TABLE Fornecedores ( 
 cnpj INT PRIMARY KEY,  
 nome_fornecedor VARCHAR(50) NOT NULL  ); 

CREATE TABLE endereco (
Id_endereco INT PRIMARY KEY,
cep INT NOT NULL,
logradouro VARCHAR(20) NOT NULL,  
numero VARCHAR(6) NOT NULL, 
complemento VARCHAR(10) NOT NULL,
bairro VARCHAR(10) NOT NULL,
cidade VARCHAR(10) NOT NULL,
estado VARCHAR(20) NOT NULL,
cnpj_fornecedores INT NOT NULL 
REFERENCES Fornecedores (cnpj) );

CREATE TABLE Telefones (
Id_telefones INT PRIMARY KEY,
principal VARCHAR(14) NOT NULL,
secundario VARCHAR(14),  
cnpj_fornecedores INT NOT NULL 
REFERENCES Fornecedores (cnpj) );

CREATE TABLE Produtos ( 
 Id INT PRIMARY KEY, 
 nome VARCHAR(20) NOT NULL,  
 fabricante VARCHAR(20) NOT NULL,  
 modelo VARCHAR(20) NOT NULL,  
 descrição VARCHAR(50),  
 valor FLOAT NOT NULL,  
 cnpj_fornecedores INT NOT NULL 
REFERENCES Fornecedores (cnpj) ); 

CREATE TABLE Controle_de_Estoque ( 
 id_c_estoque INT PRIMARY KEY,  
 operacao VARCHAR(7) NOT NULL,  
 quantidade INT NOT NULL,  
 data_hora TIMESTAMP,  
 Id_produtos INT NOT NULL
REFERENCES Produtos (Id) );

-- Inserindo dados nas tabelas (Dados meramente ilustrativos). 

INSERT INTO Fornecedores VALUES ( 11, 'CARREFOUR');
INSERT INTO Fornecedores VALUES (22, 'PÃO DE AÇÚCAR');
INSERT INTO Fornecedores VALUES (33, 'HIPER');
INSERT INTO Fornecedores VALUES (44, 'MAGAZINE LUIZA');

INSERT INTO Endereco VALUES (1, 111111,'Rua do Carrefor', 'sn', 'Carrefour', 'Carrefour', 'São Paulo', 'SP', 11);
INSERT INTO Endereco VALUES (2, 222222,'Av Pão Acucar', 'sn', 'Pao Acucar', 'Pao Acucar', 'RJ', 'RJ', 22);
INSERT INTO Endereco VALUES (3, 33333,'Av Hiper', 'sn', 'Hiper', 'Hiper', 'São Paulo', 'SP', 33);
INSERT INTO Endereco VALUES (4, 444444,'Av Magalú', 'sn', 'Magalú', 'Magalú', 'RJ', 'RJ', 44);

INSERT INTO Telefones VALUES (1, '99999-9999', '99999-9999', 11);
INSERT INTO Telefones VALUES (2, '88888-8888', '88888-8888', 22);
INSERT INTO Telefones VALUES (3, '77777-7777', '77777-7777', 33);
INSERT INTO Telefones VALUES (4, '66666-6666', '66666-6666', 44);

INSERT INTO Produtos VALUES (10001, 'liquidificador', 'arno', 'eletrônicos', 'preta', 240.00, 11);
INSERT INTO Produtos VALUES	(10002, 'sorvete', 'sterbom', 'alimentos', 'laticínios', 32.00, 22);
INSERT INTO Produtos VALUES	(10003, 'batata', 'hortinha', 'alimentos', 'hortifruti, KG', 2.50, 33);
INSERT INTO Produtos VALUES	(10004, 'lençol', 'Sono Seguro', 'cama, mesa e banho', 'conjunto 4 peças', 80.49, 44 );

INSERT INTO Controle_de_Estoque VALUES  (101, 'Entrada', 2, TIMESTAMP '2024-09-07 12:00:00', 10001);
INSERT INTO Controle_de_Estoque VALUES 	(102, 'Saída', 15, TIMESTAMP '2024-09-07 11:00:00', 10002);
INSERT INTO Controle_de_Estoque VALUES 	(103, 'Entrada', 20, TIMESTAMP '2024-09-07 10:00:00', 10003);
INSERT INTO Controle_de_Estoque VALUES 	(104, 'Saída', 5, TIMESTAMP '2024-09-07 09:00:00', 10004);
INSERT INTO Controle_de_Estoque VALUES 	(100, 'Entrada', 20, TIMESTAMP '2024-09-07 07:00:00', 10004);
INSERT INTO Controle_de_Estoque VALUES 	(105, 'Entrada', 25, TIMESTAMP '2024-09-07 08:00:00', 10004);

-- Criando view do relatório de estoque 

CREATE VIEW relatorio_estoque AS 
SELECT id, SUM 
(CASE WHEN operacao = 'Saída' THEN -quantidade ELSE quantidade
END) AS "QTE EM ESTOQUE", nome, fabricante, modelo, cnpj_fornecedores, nome_fornecedor  
FROM Produtos LEFT JOIN Controle_de_Estoque ON Id_produtos = Id 
INNER JOIN Fornecedores ON cnpj = cnpj_fornecedores 
GROUP BY Id, nome,  fabricante, modelo, cnpj_fornecedores, nome_fornecedor;

-- Visualizando o relatório de estoque

SELECT * FROM relatorio_estoque;