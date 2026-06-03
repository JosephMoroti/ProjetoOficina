CREATE DATABASE oficina_db;
USE oficina_db;

-- CLIENTES
CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  documento VARCHAR(20) UNIQUE NOT NULL,
  tipo_cliente ENUM('pessoa','industria') NOT NULL,
  telefone VARCHAR(20),
  email VARCHAR(120)
);

-- EQUIPAMENTOS
CREATE TABLE Equipamento (
  id_equipamento INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  tipo VARCHAR(50) NOT NULL, -- carro, caminhão, empilhadeira, máquina
  modelo VARCHAR(80),
  ano INT,
  placa_ou_serie VARCHAR(30),
  ativo_critico BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- TÉCNICOS
CREATE TABLE Tecnico (
  id_tecnico INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  especialidade VARCHAR(80),
  taxa_hora DECIMAL(10,2) CHECK (taxa_hora >= 0)
);

-- FORNECEDORES
CREATE TABLE Fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cnpj VARCHAR(20) UNIQUE,
  contato VARCHAR(120),
  telefone VARCHAR(20)
);

-- MATERIAIS
CREATE TABLE Material (
  id_material INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(120) NOT NULL,
  unidade VARCHAR(10) NOT NULL,
  custo_unitario DECIMAL(12,2) CHECK (custo_unitario >= 0),
  reciclavel BOOLEAN DEFAULT FALSE,
  id_fornecedor INT,
  estoque_atual DECIMAL(12,2) DEFAULT 0,
  FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor)
);

-- SERVIÇOS
CREATE TABLE Servico (
  id_servico INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(120) NOT NULL,
  tempo_previsto_min INT CHECK (tempo_previsto_min >= 0),
  preco_base DECIMAL(12,2) CHECK (preco_base >= 0)
);

-- ORDEM DE SERVIÇO
CREATE TABLE OrdemServico (
  id_os INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  id_equipamento INT NOT NULL,
  tipo_manutencao ENUM('corretiva','preventiva','preditiva'),
  status ENUM('aberta','em_execucao','concluida','cancelada'),
  prioridade ENUM('baixa','media','alta','critica'),
  iniciativa_sustentavel BOOLEAN DEFAULT FALSE,
  data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  data_inicio TIMESTAMP NULL,
  data_fim TIMESTAMP NULL,
  observacoes TEXT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_equipamento) REFERENCES Equipamento(id_equipamento)
);

-- RELAÇÃO OS-SERVIÇOS
CREATE TABLE OS_Servico (
  id_os_servico INT AUTO_INCREMENT PRIMARY KEY,
  id_os INT NOT NULL,
  id_servico INT NOT NULL,
  id_tecnico INT NOT NULL,
  tempo_real_min INT,
  custo_mao_obra DECIMAL(12,2),
  FOREIGN KEY (id_os) REFERENCES OrdemServico(id_os),
  FOREIGN KEY (id_servico) REFERENCES Servico(id_servico),
  FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico)
);

-- RELAÇÃO OS-MATERIAIS
CREATE TABLE OS_Material (
  id_os_material INT AUTO_INCREMENT PRIMARY KEY,
  id_os INT NOT NULL,
  id_material INT NOT NULL,
  quantidade DECIMAL(12,2) CHECK (quantidade > 0),
  FOREIGN KEY (id_os) REFERENCES OrdemServico(id_os),
  FOREIGN KEY (id_material) REFERENCES Material(id_material)
);

-- PAGAMENTOS
CREATE TABLE Pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_os INT NOT NULL,
  forma ENUM('pix','cartao','boleto','transferencia','dinheiro'),
  valor_total DECIMAL(12,2),
  imposto DECIMAL(12,2) DEFAULT 0,
  data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_os) REFERENCES OrdemServico(id_os)
);