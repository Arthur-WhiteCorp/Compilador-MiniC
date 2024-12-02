# Compilador-MiniC

## Projeto: Compilador MiniC para Arquitetura RISC de 8 bits

### Autor: Arthur Silva Matias

#### Descrição

Este projeto consiste no código fonte de um **compilador** para a linguagem **MiniC**, uma linguagem de programação baseada em **C** desenvolvida por mim, projetada especificamente para ser executada em uma **arquitetura RISC de 8 bits**. O compilador foi criado com o objetivo de ser utilizado como ferramenta educacional pelo professor **Juan Colonna**, da **Universidade Federal do Amazonas (UFAM)**, para fins de ensino de conceitos fundamentais de compiladores e arquitetura de sistemas.

A linguagem **MiniC** possui sintaxe inspirada em C, mas simplificada para facilitar o aprendizado. O compilador foi implementado utilizando a linguagem **C++** e faz uso do **ANTLR4** para gerar o **lexer** e o **parser**. ANTLR4 é uma poderosa ferramenta para a construção de compiladores e intérpretes, permitindo a definição de gramáticas complexas de maneira simples e eficiente.

O processo de construção do projeto é gerido pelo sistema de **build CMake**, que facilita a configuração e a geração dos arquivos de compilação para diferentes plataformas. O código é organizado em diretórios bem definidos, incluindo:
- **`src/`**: para o código fonte.
- **`grammar/`**: para os arquivos de definição da gramática ANTLR.
- **`headers/`**: para os arquivos de cabeçalho do C++.

A **arquitetura RISC de 8 bits** foi escolhida devido à sua simplicidade e eficiência, permitindo aos alunos compreenderem melhor os fundamentos da execução de programas em sistemas de baixo nível. O objetivo do compilador **MiniC** é compilar programas escritos em **MiniC** para **código de máquina** executável diretamente na arquitetura alvo de 8 bits.

### Linguagens e Ferramentas Utilizadas:
- **Linguagem de Programação**: C++
- **Parser/Lexer**: ANTLR4
- **Sistema de Build**: CMake
- **Arquitetura**: RISC de 8 bits
- **Objetivo Educacional**: Ensino de compiladores e arquitetura de sistemas

---

Este projeto visa não apenas a criação de um compilador funcional, mas também a promoção de uma compreensão mais profunda dos conceitos de **compiladores** e **arquitetura de sistemas** para estudantes de graduação.
