
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import subprocess
import os

# PROJECT PATH
BASE_DIR = os.path.dirname(
    os.path.dirname(
        os.path.abspath(__file__)
    )
)

COMPILER_PATH = os.path.join(
    BASE_DIR,
    "compiler.exe"
)


# EXAMPLE CODE
C_CODE = """#include <stdio.h>

int main()
{
    int x;

    x = 20 * 2 + 10;

    printf("%d", x);

    return 0;
}
"""


CPP_CODE = """#include <iostream>

int main()
{
    int x;

    x = 20 * 2 + 10;

    cout << x;

    return 0;
}
"""


JAVA_CODE = """public static void main(String args[])
{
    int x;

    x = 20 * 2 + 10;

    System.out.println(x);
}
"""

# TEXT OUTPUT HELPER
def set_text(widget, text):

    widget.config(state="normal")

    widget.delete(
        "1.0",
        tk.END
    )

    widget.insert(
        tk.END,
        text
    )

    widget.config(state="disabled")

# LANGUAGE CHANGE
def language_changed(event=None):

    language = language_var.get()

    source_text.delete(
        "1.0",
        tk.END
    )

    if language == "C":

        source_text.insert(
            tk.END,
            C_CODE
        )

    elif language == "C++":

        source_text.insert(
            tk.END,
            CPP_CODE
        )

    elif language == "Java":

        source_text.insert(
            tk.END,
            JAVA_CODE
        )

    status_label.config(
        text=f"Language selected: {language}"
    )

# CLEAR
def clear_all():

    source_text.delete(
        "1.0",
        tk.END
    )

    for widget in output_widgets:

        set_text(
            widget,
            ""
        )

    status_label.config(
        text="Ready"
    )

# SECTION EXTRACTION
def extract_sections(output):

    sections = {
        "lexer": "",
        "parser": "",
        "semantic": "",
        "tac": "",
        "optimization": "",
        "codegen": ""
    }

    lines = output.splitlines()

    lexer = []
    parser = []
    semantic = []
    tac = []
    optimization = []
    codegen = []

    current = "lexer"

    for line in lines:

        lower = line.lower().strip()

        # ==========================================
        # SYMBOL TABLE → SEMANTIC
        # ==========================================
        if (
            "symbol table" in lower
            or "semantic analysis" in lower
            or "semantic error" in lower
        ):
            current = "semantic"
            semantic.append(line)
            continue

        # ==========================================
        # TAC / INTERMEDIATE CODE
        # ==========================================
        if (
            "intermediate code generation" in lower
            or "intermediate code" in lower
            or "three address code" in lower
        ):
            current = "tac"
            tac.append(line)
            continue

        # ==========================================
        # OPTIMIZATION
        # ==========================================
        if (
            "optimized code" in lower
            or "optimization" in lower
        ):
            current = "optimization"
            optimization.append(line)
            continue

        # ==========================================
        # TARGET CODE
        # ==========================================
        if (
            "target code" in lower
            or "generated code" in lower
            or "code generation" in lower
        ):
            current = "codegen"
            codegen.append(line)
            continue

        # ==========================================
        # PARSER
        # ==========================================
        if (
            "parsing successful" in lower
            or "parsing failed" in lower
            or "syntax error" in lower
            or "parsing completed" in lower
        ):
            current = "parser"
            parser.append(line)
            continue

        # ==========================================
        # STORE CURRENT SECTION
        # ==========================================

        if current == "lexer":
            lexer.append(line)

        elif current == "parser":
            parser.append(line)

        elif current == "semantic":
            semantic.append(line)

        elif current == "tac":
            tac.append(line)

        elif current == "optimization":
            optimization.append(line)

        elif current == "codegen":
            codegen.append(line)

    # ==========================================
    # SAVE SECTIONS
    # ==========================================

    sections["lexer"] = "\n".join(lexer)

    sections["parser"] = "\n".join(parser)

    sections["semantic"] = "\n".join(semantic)

    sections["tac"] = "\n".join(tac)

    sections["optimization"] = "\n".join(
        optimization
    )

    sections["codegen"] = "\n".join(codegen)

    return sections

# COMPILE
def compile_code():

    source_code = source_text.get(
        "1.0",
        tk.END
    ).strip()


    if not source_code:

        messagebox.showwarning(
            "Empty Source",
            "Please enter source code."
        )

        return


    if not os.path.exists(COMPILER_PATH):

        messagebox.showerror(
            "Compiler Not Found",

            "compiler.exe was not found.\n\n"

            f"Expected location:\n{COMPILER_PATH}"
        )

        return


    language = language_var.get()


    status_label.config(
        text=f"Compiling {language}..."
    )

    root.update_idletasks()


    try:

        process = subprocess.run(

            [COMPILER_PATH],

            input=source_code,

            text=True,

            capture_output=True,

            cwd=BASE_DIR
        )


        output = ""


        output += (
            f"========== {language} COMPILER ==========\n\n"
        )


        if process.stdout:

            output += process.stdout


        if process.stderr:

            output += (
                "\n\n"
                "========== ERRORS / WARNINGS ==========\n"
            )

            output += process.stderr

        # ALL OUTPUT
        set_text(
            all_output_text,
            output
        )
        
        # EXTRACT
        sections = extract_sections(
            output
        )


        set_text(
            lexer_text,
            sections["lexer"]
        )


        set_text(
            parser_text,
            sections["parser"]
        )


        set_text(
            semantic_text,
            sections["semantic"]
        )


        set_text(
            tac_text,
            sections["tac"]
        )


        set_text(
            optimization_text,
            sections["optimization"]
        )


        set_text(
            codegen_text,
            sections["codegen"]
        )


        # STATUS
        if process.returncode == 0:

            status_label.config(
                text=(
                    f"✓ {language} compilation completed"
                )
            )

        else:

            status_label.config(
                text=(
                    f"✗ {language} compilation failed"
                )
            )


    except Exception as error:

        messagebox.showerror(
            "Compilation Error",
            str(error)
        )

        status_label.config(
            text="Compilation Error"
        )

# SAVE
def save_source():

    code = source_text.get(
        "1.0",
        tk.END
    ).strip()


    if not code:

        messagebox.showwarning(
            "Empty",
            "Nothing to save."
        )

        return


    language = language_var.get()


    if language == "C":

        extension = ".c"

    elif language == "C++":

        extension = ".cpp"

    else:

        extension = ".java"


    path = filedialog.asksaveasfilename(

        defaultextension=extension,

        filetypes=[

            (
                f"{language} Source",
                f"*{extension}"
            ),

            (
                "All Files",
                "*.*"
            )

        ]
    )


    if path:

        with open(
            path,
            "w",
            encoding="utf-8"
        ) as file:

            file.write(code)


        status_label.config(
            text=f"Saved: {os.path.basename(path)}"
        )


# LOAD
def load_source():

    path = filedialog.askopenfilename(

        filetypes=[

            (
                "Source Files",
                "*.c *.cpp *.java *.txt"
            ),

            (
                "All Files",
                "*.*"
            )

        ]
    )


    if not path:

        return


    try:

        with open(
            path,
            "r",
            encoding="utf-8"
        ) as file:

            code = file.read()


        source_text.delete(
            "1.0",
            tk.END
        )

        source_text.insert(
            tk.END,
            code
        )


        extension = os.path.splitext(
            path
        )[1].lower()


        if extension == ".c":

            language_var.set("C")

        elif extension == ".cpp":

            language_var.set("C++")

        elif extension == ".java":

            language_var.set("Java")


        status_label.config(
            text=f"Loaded: {os.path.basename(path)}"
        )


    except Exception as error:

        messagebox.showerror(
            "Load Error",
            str(error)
        )


# MAIN WINDOW
root = tk.Tk()

root.title(
    "Mini Compiler Front-End"
)

root.geometry(
    "1450x850"
)

root.minsize(
    1100,
    650
)

root.configure(
    bg="#1e1e1e"
)

# STYLE
style = ttk.Style()

try:

    style.theme_use(
        "clam"
    )

except:

    pass


style.configure(

    "Title.TLabel",

    background="#1e1e1e",

    foreground="white",

    font=(
        "Segoe UI",
        21,
        "bold"
    )
)


style.configure(

    "Normal.TLabel",

    background="#1e1e1e",

    foreground="#cccccc",

    font=(
        "Segoe UI",
        10
    )
)


style.configure(

    "Compile.TButton",

    font=(
        "Segoe UI",
        10,
        "bold"
    ),

    padding=(
        18,
        7
    )
)


style.configure(

    "Normal.TButton",

    font=(
        "Segoe UI",
        10
    ),

    padding=(
        15,
        7
    )
)


style.configure(

    "TNotebook",

    background="#1e1e1e",

    borderwidth=0
)


style.configure(

    "TNotebook.Tab",

    padding=(
        13,
        7
    ),

    font=(
        "Segoe UI",
        9,
        "bold"
    )
)

# HEADER
header = tk.Frame(
    root,
    bg="#1e1e1e"
)

header.pack(
    fill="x",
    padx=20,
    pady=(15, 5)
)


title = ttk.Label(

    header,

    text="Mini Compiler Front-End",

    style="Title.TLabel"
)

title.pack(
    side="left"
)

# TOP CONTROL BAR
control_frame = tk.Frame(
    root,
    bg="#1e1e1e"
)

control_frame.pack(
    fill="x",
    padx=20,
    pady=8
)


# Language

language_label = ttk.Label(

    control_frame,

    text="Language:",

    style="Normal.TLabel"
)

language_label.pack(
    side="left",
    padx=(0, 8)
)


language_var = tk.StringVar(
    value="C"
)


language_combo = ttk.Combobox(

    control_frame,

    textvariable=language_var,

    values=[
        "C",
        "C++",
        "Java"
    ],

    state="readonly",

    width=12
)

language_combo.pack(
    side="left",
    padx=(0, 20)
)


language_combo.bind(
    "<<ComboboxSelected>>",
    language_changed
)


# Compile

compile_button = ttk.Button(

    control_frame,

    text="▶  Compile",

    style="Compile.TButton",

    command=compile_code
)

compile_button.pack(
    side="left",
    padx=4
)


# Clear

clear_button = ttk.Button(

    control_frame,

    text="🗑  Clear",

    style="Normal.TButton",

    command=clear_all
)

clear_button.pack(
    side="left",
    padx=4
)


# Save

save_button = ttk.Button(

    control_frame,

    text="Save",

    style="Normal.TButton",

    command=save_source
)

save_button.pack(
    side="left",
    padx=4
)


# Load

load_button = ttk.Button(

    control_frame,

    text="Load",

    style="Normal.TButton",

    command=load_source
)

load_button.pack(
    side="left",
    padx=4
)


# MAIN SPLIT AREA
main_frame = tk.Frame(
    root,
    bg="#1e1e1e"
)

main_frame.pack(
    fill="both",
    expand=True,
    padx=20,
    pady=8
)

# LEFT SIDE
left_frame = tk.Frame(
    main_frame,
    bg="#252526"
)

left_frame.pack(
    side="left",
    fill="both",
    expand=True,
    padx=(0, 8)
)


left_title = tk.Label(

    left_frame,

    text="SOURCE CODE",

    bg="#252526",

    fg="white",

    font=(
        "Segoe UI",
        11,
        "bold"
    )
)

left_title.pack(
    anchor="w",
    padx=12,
    pady=10
)


source_text = tk.Text(

    left_frame,

    bg="#1e1e1e",

    fg="#d4d4d4",

    insertbackground="white",

    selectbackground="#264f78",

    font=(
        "Consolas",
        12
    ),

    undo=True,

    wrap="none"
)

source_text.pack(
    side="left",
    fill="both",
    expand=True,
    padx=(10, 0),
    pady=(0, 10)
)


source_scroll = tk.Scrollbar(

    left_frame,

    command=source_text.yview
)

source_scroll.pack(
    side="right",
    fill="y",
    padx=(0, 10),
    pady=(0, 10)
)


source_text.configure(
    yscrollcommand=source_scroll.set
)


# RIGHT SIDE
right_frame = tk.Frame(
    main_frame,
    bg="#252526"
)

right_frame.pack(
    side="right",
    fill="both",
    expand=True,
    padx=(8, 0)
)


right_title = tk.Label(

    right_frame,

    text="COMPILATION OUTPUT",

    bg="#252526",

    fg="white",

    font=(
        "Segoe UI",
        11,
        "bold"
    )
)

right_title.pack(
    anchor="w",
    padx=12,
    pady=10
)


# NOTEBOOK
notebook = ttk.Notebook(
    right_frame
)

notebook.pack(
    fill="both",
    expand=True,
    padx=8,
    pady=(0, 10)
)


# TAB CREATOR
output_widgets = []


def create_tab(title):

    frame = tk.Frame(
        notebook,
        bg="#1e1e1e"
    )


    text = tk.Text(

        frame,

        bg="#1e1e1e",

        fg="#d4d4d4",

        insertbackground="white",

        selectbackground="#264f78",

        font=(
            "Consolas",
            10
        ),

        wrap="none"
    )


    text.pack(
        side="left",
        fill="both",
        expand=True
    )


    scrollbar = tk.Scrollbar(

        frame,

        command=text.yview
    )


    scrollbar.pack(
        side="right",
        fill="y"
    )


    text.configure(
        yscrollcommand=scrollbar.set
    )


    text.config(
        state="disabled"
    )


    notebook.add(
        frame,
        text=title
    )


    output_widgets.append(
        text
    )


    return text

# CREATE TABS
lexer_text = create_tab(
    "Lexer"
)

parser_text = create_tab(
    "Parser"
)

semantic_text = create_tab(
    "Semantic"
)

tac_text = create_tab(
    "TAC"
)

optimization_text = create_tab(
    "Optimization"
)

codegen_text = create_tab(
    "Target Code"
)

all_output_text = create_tab(
    "All Output"
)



# STATUS BAR
status_label = tk.Label(

    root,

    text="Ready",

    bg="#1e1e1e",

    fg="#888888",

    anchor="w",

    font=(
        "Segoe UI",
        9
    )
)

status_label.pack(
    fill="x",
    padx=20,
    pady=(2, 8)
)

# DEFAULT CODE
language_changed()

# START
root.mainloop()

