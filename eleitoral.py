from sqlalchemy import create_engine
import psycopg2
import pyodbc
import tkinter as tk
from tkinter import ttk, messagebox

try:
    conn = psycopg2.connect(
        host='localhost',
        user='postgres',
        password='27182',
        port='5432',
        database='TrabF'
    )
    conn.close()  # Fecha a conexão inicial de teste
except psycopg2.connector.Error as err:
    print(f"Error: {err}")
    exit(1)

class SistemaEleitoralApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Sistema Eleitoral")
        
        self.create_widgets()

    def create_widgets(self):
        self.tabs = ttk.Notebook(self.root)
        
        self.tab_listar_remover = ttk.Frame(self.tabs)
        self.tab_candidaturas = ttk.Frame(self.tabs)
        self.tab_relatorio = ttk.Frame(self.tabs)
        self.tab_ficha_limpa = ttk.Frame(self.tabs)
        
        self.tabs.add(self.tab_listar_remover, text="Listar e Remover Dados")
        self.tabs.add(self.tab_candidaturas, text="Listar Candidaturas")
        self.tabs.add(self.tab_relatorio, text="Relatório de Candidaturas")
        self.tabs.add(self.tab_ficha_limpa, text="Ficha Limpa")
        
        self.tabs.pack(expand=1, fill="both")
        
        self.create_listar_remover_tab()
        self.create_candidaturas_tab()
        self.create_relatorio_tab()
        self.create_ficha_limpa_tab()

    def create_listar_remover_tab(self):
        self.treeview = ttk.Treeview(self.tab_listar_remover, columns=("id", "tipo", "dados"), show="headings")
        self.treeview.heading("id", text="ID")
        self.treeview.heading("tipo", text="Tipo")
        self.treeview.heading("dados", text="Dados")
        
        self.treeview.pack(expand=1, fill="both")
        
        self.btn_listar = ttk.Button(self.tab_listar_remover, text="Listar Dados", command=self.listar_dados)
        self.btn_listar.pack(side="left", padx=5, pady=5)
        
        self.btn_remover = ttk.Button(self.tab_listar_remover, text="Remover Selecionado", command=self.remover_dados)
        self.btn_remover.pack(side="left", padx=5, pady=5)

    def listar_dados(self):
        for item in self.treeview.get_children():
            self.treeview.delete(item)
        
        conn = psycopg2.connect(
            host='localhost',
            user='postgres',
            password='27182',
            port='5432',
            database='TrabF'
        )
        cursor = conn.cursor()
        
        entities = ["Individuo", "PessoaFisica", "PessoaJuridica", "Processo", "Ficha", "Candidato", 
                    "Partido", "Programa", "Cargo", "Pleito", "Candidatura", "DoacaoPJ", "DoacaoPF", "Apoiador", "EquipeApoio"]
        
        for entity in entities:
            cursor.execute(f"SELECT * FROM {entity}")
            rows = cursor.fetchall()
            for row in rows:
                self.treeview.insert("", "end", values=(row[0], entity, row))
        
        conn.close()

    def remover_dados(self):
        selected_item = self.treeview.selection()
        if selected_item:
            item = self.treeview.item(selected_item)
            item_id = item['values'][0]
            item_type = item['values'][1]
            
            conn = psycopg2.connect(
                host='localhost',
                user='postgres',
                password='27182',
                port='5432',
                database='TrabF'
            )   
            cursor = conn.cursor()
            
            if item_type in ["Individuo", "Processo", "Programa", "Cargo", "Pleito"]:
                cursor.execute(f"DELETE FROM {item_type} WHERE {item_type}.id{item_type} = %s", (item_id,))
            elif item_type in ["PessoaFisica", "PessoaJuridica"]:
                cursor.execute(f"DELETE FROM {item_type} WHERE {item_type}.CPF = %s", (item_id,))
            else:
                cursor.execute(f"DELETE FROM {item_type} WHERE {item_type}.NumCandidato = %s", (item_id,))
            
            conn.commit()
            conn.close()
            
            self.treeview.delete(selected_item)
        else:
            messagebox.showwarning("Seleção inválida", "Por favor, selecione um item para remover.")

    def create_candidaturas_tab(self):
        self.lbl_ano = ttk.Label(self.tab_candidaturas, text="Ano:")
        self.lbl_ano.grid(row=0, column=0, padx=5, pady=5)
        
        self.entry_ano = ttk.Entry(self.tab_candidaturas)
        self.entry_ano.grid(row=0, column=1, padx=5, pady=5)
        
        self.lbl_nome_candidato = ttk.Label(self.tab_candidaturas, text="Nome do Candidato:")
        self.lbl_nome_candidato.grid(row=0, column=2, padx=5, pady=5)
        
        self.entry_nome_candidato = ttk.Entry(self.tab_candidaturas)
        self.entry_nome_candidato.grid(row=0, column=3, padx=5, pady=5)
        
        self.lbl_cargo = ttk.Label(self.tab_candidaturas, text="Cargo:")
        self.lbl_cargo.grid(row=0, column=4, padx=5, pady=5)
        
        self.entry_cargo = ttk.Entry(self.tab_candidaturas)
        self.entry_cargo.grid(row=0, column=5, padx=5, pady=5)
        
        self.btn_listar_candidaturas = ttk.Button(self.tab_candidaturas, text="Listar Candidaturas", command=self.listar_candidaturas)
        self.btn_listar_candidaturas.grid(row=0, column=6, padx=5, pady=5)
        
        self.treeview_candidaturas = ttk.Treeview(self.tab_candidaturas, columns=("ano", "nome_candidato", "cargo"), show="headings")
        self.treeview_candidaturas.heading("ano", text="Ano")
        self.treeview_candidaturas.heading("nome_candidato", text="Nome do Candidato")
        self.treeview_candidaturas.heading("cargo", text="Cargo")
        
        self.treeview_candidaturas.grid(row=1, column=0, columnspan=7, padx=5, pady=5, sticky="nsew")

    def listar_candidaturas(self):
        for item in self.treeview_candidaturas.get_children():
            self.treeview_candidaturas.delete(item)
        
        ano = self.entry_ano.get()
        nome_candidato = self.entry_nome_candidato.get()
        cargo = self.entry_cargo.get()
        
        query = """
        SELECT Candidatura.idPleito, Candidato.Nome, Cargo.Cidade, Cargo.Estado, Pleito.Data
        FROM Candidatura
        JOIN Candidato ON Candidatura.NumCandidato = Candidato.NumCandidato
        JOIN Cargo ON Candidatura.idCargo = Cargo.idCargo
        JOIN Pleito ON Candidatura.idPleito = Pleito.idPleito
        WHERE 1=1
        """
        
        params = []
        if ano:
            query += " AND EXTRACT(YEAR FROM Pleito.Data) = %s"
            params.append(ano)
        if nome_candidato:
            query += " AND Candidato.Nome LIKE %s"
            params.append(f"%{nome_candidato}%")
        if cargo:
            query += " AND (Cargo.Cidade LIKE %s OR Cargo.Estado LIKE %s)"
            params.append(f"%{cargo}%")
            params.append(f"%{cargo}%")
        
        conn = psycopg2.connect(
            host='localhost',
            user='postgres',
            password='27182',
            port='5432',
            database='TrabF'
        )
        cursor = conn.cursor()
        cursor.execute(query, tuple(params))
        
        rows = cursor.fetchall()
        for row in rows:
            self.treeview_candidaturas.insert("", "end", values=row)
        
        conn.close()

    def create_relatorio_tab(self):
        self.btn_gerar_relatorio = ttk.Button(self.tab_relatorio, text="Gerar Relatório de Candidaturas", command=self.gerar_relatorio)
        self.btn_gerar_relatorio.pack(padx=5, pady=5)
        
        self.text_relatorio = tk.Text(self.tab_relatorio)
        self.text_relatorio.pack(expand=1, fill="both", padx=5, pady=5)


    def gerar_relatorio(self):
        self.text_relatorio.delete("1.0", tk.END)
        
        conn = psycopg2.connect(
            host='localhost',
            user='postgres',
            password='27182',
            port='5432',
            database='TrabF'
        )
        cursor = conn.cursor()
        
        query = """
        SELECT Pleito.idPleito, Candidato.Nome, Cargo.Cidade, Cargo.Estado, Candidatura.SeElege
        FROM Candidatura
        JOIN Candidato ON Candidatura.NumCandidato = Candidato.NumCandidato
        JOIN Cargo ON Candidatura.idCargo = Cargo.idCargo
        JOIN Pleito ON Candidatura.idPleito = Pleito.idPleito
        """
        
        cursor.execute(query)
        
        rows = cursor.fetchall()
        relatorio = "ID Pleito\tNome do Candidato\tCargo (Cidade, Estado)\tEleito\n"
        relatorio += "-" * 50 + "\n"
        for row in rows:
            relatorio += f"{row[0]}\t{row[1]}\t{row[2]}, {row[3]}\t{'Sim' if row[4] else 'Não'}\n"
        
        self.text_relatorio.insert(tk.END, relatorio)
        
        conn.close()

    def create_ficha_limpa_tab(self):
        self.lbl_ficha_limpa = ttk.Label(self.tab_ficha_limpa, text="Digite o nome do candidato:")
        self.lbl_ficha_limpa.pack(padx=5, pady=5)
        
        self.entry_ficha_limpa = ttk.Entry(self.tab_ficha_limpa)
        self.entry_ficha_limpa.pack(padx=5, pady=5)
        
        self.btn_verificar_ficha_limpa = ttk.Button(self.tab_ficha_limpa, text="Verificar Ficha Limpa", command=self.verificar_ficha_limpa)
        self.btn_verificar_ficha_limpa.pack(padx=5, pady=5)
        
        self.text_ficha_limpa = tk.Text(self.tab_ficha_limpa)
        self.text_ficha_limpa.pack(expand=1, fill="both", padx=5, pady=5)

    def verificar_ficha_limpa(self):
        self.text_ficha_limpa.delete("1.0", tk.END)
        
        nome_candidato = self.entry_ficha_limpa.get()
        
        conn = psycopg2.connect(
            host='localhost',
            user='postgres',
            password='27182',
            port='5432',
            database='TrabF'
        )   
        cursor = conn.cursor()
        
        query = """
        SELECT Candidato.Nome, Processo.Tipo, Processo.Data, Processo.Status
        FROM Candidato
        JOIN Ficha ON Candidato.idIndividuo = Ficha.idIndividuo
        JOIN Processo ON Ficha.idProcesso = Processo.idProcesso
        WHERE Candidato.Nome LIKE %s
        """
        
        cursor.execute(query, (f"%{nome_candidato}%",))
        
        rows = cursor.fetchall()
        if rows:
            for row in rows:
                self.text_ficha_limpa.insert(tk.END, f"Nome: {row[0]}\nTipo do Processo: {row[1]}\nData do Processo: {row[2]}\nStatus do Processo: {row[3]}\n\n")
        else:
            self.text_ficha_limpa.insert(tk.END, "Nenhum registro encontrado.")
        
        conn.close()


if __name__ == "__main__":
    root = tk.Tk()
    app = SistemaEleitoralApp(root)
    root.mainloop()