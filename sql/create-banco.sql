CREATE SCHEMA bellamassa;


CREATE TABLE bellamassa.cliente (
  id_cliente  INT PRIMARY KEY,
  nome_completo varchar(50) NOT NULL,
  telefone varchar(14) NOT NULL
);

CREATE TABLE bellamassa.conta_fidelidade (
  id_conta INT PRIMARY key,
  fk_id_cliente INT    NOT NULL,
  saldo numeric NOT NULL,

  CONSTRAINT fk_conta_cliente
    FOREIGN KEY (fk_id_cliente)
    REFERENCES bellamassa.cliente (id_cliente)
    ON DELETE CASCADE
);

CREATE TABLE bellamassa.endereco (
  id_endereco INT primary key,
  fk_id_cliente INT,
  rua varchar(100) not null,
  numero int not null,
  bairro varchar(50) not null,
  cep varchar(9) not null,

  CONSTRAINT fk_endereco_cliente
    FOREIGN KEY (fk_id_cliente)
    REFERENCES bellamassa.cliente (id_cliente)
    ON DELETE CASCADE
);

CREATE TABLE bellamassa.motoboy(
  cpf varchar(14) primary key,
  nome_motoboy varchar(100),
  tel_motoboy varchar(14)
);

CREATE TABLE bellamassa.produto(
  id_produto INT primary key,
  nome_produto varchar(150) not null,
  preco_base numeric not null,
  tipo varchar(100) not null
);

CREATE TABLE bellamassa.pedido (
  id_pedido     INT PRIMARY KEY,
  fk_id_cliente INT NOT NULL,
  cpf_motoboy   VARCHAR(14),
  data_hora     TIMESTAMP NOT NULL DEFAULT now(),
  valor_total   NUMERIC,

  CONSTRAINT fk_pedido_cliente
    FOREIGN KEY (fk_id_cliente)
    REFERENCES bellamassa.cliente (id_cliente)
    ON DELETE RESTRICT,

  CONSTRAINT fk_pedido_motoboy
    FOREIGN KEY (cpf_motoboy)
    REFERENCES bellamassa.motoboy (cpf)
    ON DELETE SET NULL
);

CREATE TABLE bellamassa.pedido_produto (
  id_ped_prod    INT PRIMARY KEY,
  id_pedido      INT NOT NULL,
  id_produto     INT NOT NULL,
  quantidade     INT NOT NULL DEFAULT 1,
  preco_unitario NUMERIC NOT NULL,

  CONSTRAINT fk_pp_pedido
    FOREIGN KEY (id_pedido)
    REFERENCES bellamassa.pedido (id_pedido)
    ON DELETE CASCADE,

  CONSTRAINT fk_pp_produto
    FOREIGN KEY (id_produto)
    REFERENCES bellamassa.produto (id_produto)
    ON DELETE RESTRICT
);