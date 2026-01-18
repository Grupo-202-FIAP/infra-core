# Guia de Configuração: Novo Usuário e Segurança SSH (Ubuntu AWS)

Este documento detalha o passo a passo para criar um novo usuário com privilégios administrativos, configurar o acesso via chave SSH (`.pem`) existente e bloquear o acesso direto ao root para aumentar a segurança do servidor.

---

## 1. Acessar o servidor como usuário padrão

Primeiro, conecte-se usando o usuário padrão da AWS (`ubuntu`):

```bash
ssh -i "ssh_arch.pem" ubuntu@<EC2_PUBLIC_IP>
```

> **Nota:** Substitua `<EC2_PUBLIC_IP>` pelo endereço IP público da sua instância EC2 Bastion.

---

## 2. Criar o novo usuário e dar permissões

Execute os comandos abaixo no servidor. Substitua `seu_usuario` pelo nome desejado (ex: `matheus`).

### 2.1 Criar usuário

```bash
sudo adduser seu_usuario
```

> Defina uma senha quando solicitado. As outras informações podem ser deixadas em branco (Enter).

### 2.2 Conceder permissão de Root (Sudo)

```bash
sudo usermod -aG sudo seu_usuario
```

---

## 3. Configurar a Chave SSH para o novo usuário

Para usar o mesmo arquivo `.pem` que você já tem, precisamos copiar a chave autorizada do usuário `ubuntu` para o novo usuário.

```bash
# 1. Criar o diretório .ssh na home do novo usuário
sudo mkdir -p /home/seu_usuario/.ssh

# 2. Copiar as chaves autorizadas do usuário atual (ubuntu)
sudo cp /home/ubuntu/.ssh/authorized_keys /home/seu_usuario/.ssh/

# 3. Ajustar o dono dos arquivos para o novo usuário
sudo chown -R seu_usuario:seu_usuario /home/seu_usuario/.ssh

# 4. Ajustar permissões de segurança (Crítico para o SSH funcionar)
sudo chmod 700 /home/seu_usuario/.ssh
sudo chmod 600 /home/seu_usuario/.ssh/authorized_keys
```

---

## 4. Testar o acesso

⚠️ **Importante:** Não pule esta etapa!

Mantenha o terminal atual aberto e abra uma nova janela ou aba no seu terminal local. Tente conectar com o novo usuário:

```bash
ssh -i "ssh_arch.pem" seu_usuario@<EC2_PUBLIC_IP>
```

### Se conectar com sucesso:

1. Teste o comando sudo:

   ```bash
   sudo apt update
   ```

2. Se pedir a senha e funcionar, você pode prosseguir para o bloqueio do root.

---

## 5. Bloquear acesso SSH ao Root

De volta ao terminal conectado ao servidor, edite a configuração do SSH.

### 5.1 Abrir o arquivo de configuração

```bash
sudo nano /etc/ssh/sshd_config
```

### 5.2 Desabilitar login do root

Localize a linha `PermitRootLogin`. Se ela estiver como `yes` ou comentada (`#`), altere para:

```conf
PermitRootLogin no
```

### 5.3 (Opcional) Desativar login por senha

Para garantir que apenas quem tem a chave `.pem` entre, verifique se esta linha está assim:

```conf
PasswordAuthentication no
```

### 5.4 Salvar o arquivo

1. Pressione `Ctrl+O` e `Enter` para salvar
2. Pressione `Ctrl+X` para sair

---

## 6. Aplicar as alterações

Reinicie o serviço SSH para que as novas configurações entrem em vigor:

```bash
sudo systemctl restart ssh
```

---

## ✅ Conclusão

Seu servidor está agora configurado com:

- ✅ Um usuário nominal com poderes de `sudo`
- ✅ Acesso via chave SSH (`.pem`) configurado
- ✅ Acesso direto ao `root` bloqueado
- ✅ Segurança SSH aumentada

---

## Referência Rápida

| Comando | Descrição |
|---------|-----------|
| `sudo adduser usuario` | Criar novo usuário |
| `sudo usermod -aG sudo usuario` | Conceder acesso sudo |
| `sudo nano /etc/ssh/sshd_config` | Editar configurações SSH |
| `sudo systemctl restart ssh` | Reiniciar serviço SSH |
