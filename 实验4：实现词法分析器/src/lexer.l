%option noyywrap
%option nounput
%option noinput
%top{
    #include <stdarg.h>
    #include "common.h"
    #include <string>
    #include <unordered_map>
    using namespace std;
}
%{
    extern dump_type_t dump_type;

    inline void dump_tokens(const char* format, ...){
        va_list args;
        va_start(args, format);
        if (dump_type == TOKENS)
            vfprintf(yyout, format, args);
        va_end(args);
    }

    /* Your code here, if desired (lab3). */
    int column=1;
    struct node {
        char name[40];
        node* prev, * next;
    };

    node* add(char* s) {
        node *id_elem = new node();
        strcpy(id_elem->name, s);
        return id_elem;
    }

    class symbol_table {
    private:
        unordered_map<string, node*> map;
        symbol_table* prev;
    public:
        symbol_table() {
            prev = nullptr;
        }
        symbol_table(symbol_table* back) {
            prev = back;
        }
        void add_into_map(string name, node* id) {
            map[name] = id;
        }
        symbol_table* get_prev() {
            return prev;
        }
        node* get_identifier(string name) {
            if (map.empty()) {
                return nullptr;
            }
            else if (map.find(name) != map.end()) {
                return map[name];
            }
            else {
                return nullptr;
            }
        }
    };

    class symbol_stack: public symbol_table {
    private:
        symbol_table* top;
    public:
        symbol_stack() {
            symbol_table* t = new symbol_table();
            top = t;
        }

        void push() {
            symbol_table* t = new symbol_table(top);
            top = t;
        }

        void pop() {
            symbol_table* p;
            p = top;
            top = top->get_prev();
            p->~symbol_table();
        }

        node* lookup(string name) {
            node* p_entry = nullptr;
            symbol_table* p;
            p = top;
            do {
                p_entry = p->get_identifier(name);
                if (p_entry) {
                    return p_entry;
                }
                p = p->get_prev();
            } while (p);
            /*p_entry = p->get_identifier(name);
            if (p_entry) {
                return p_entry;
            }*/
            p_entry = add((char*)name.c_str());
            top->add_into_map(name, p_entry);
            return p_entry;
        }
    };

    symbol_stack stack;
%}

/* definitions section */
DECIMIAL ([1-9][0-9]*|0)
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)
WHITE [\t ]
/*  Your code here (lab3). */
OCTAL (0[0-7]+)           
HEXADECIMAL (0[xX][0-9A-Fa-f]+)
FLOAT ([0-9]*)([.][0-9]+)?([eE][+-]?[0-9]+)?
%x BLOCKCOMMENT            
BLOCKCOMMENTBEGIN "/*"           
BLOCKCOMMENTELEMENT .|\n         
BLOCKCOMMENTEND "*/" 
LINECOMMENT \/\/[^\n]*  
%%
    /* rules section */
"int" {
    dump_tokens("INT\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=strlen("int");
}

"void" {
    dump_tokens("VOID\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=strlen("void");
}

"if" {
    dump_tokens("IF\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=strlen("if");
}

"else" {
    dump_tokens("ELSE\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=4;
}

"return" {
    dump_tokens("RETURN\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=6;
}

"const" {
    dump_tokens("CONST\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=5;
}
"while" {
    dump_tokens("WHILE\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=5;
}
"break" {
    dump_tokens("BREAK\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=5;
}

"continue" {
    dump_tokens("CONTINUE\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=8;
}

"=" {
    dump_tokens("ASSIGN\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"==" {
    dump_tokens("EQUAL\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=2;
}

"!=" {
    dump_tokens("NOTEQUAL\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=2;
}

"<" {
    dump_tokens("LESS\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

">" {
    dump_tokens("GREATER\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"<=" {
    dump_tokens("LESSEQUAL\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=2;
}

">=" {
    dump_tokens("GREATEREQUAL\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=2;
}

"+" {
    dump_tokens("ADD\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"-" {
    dump_tokens("SUB\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"*" {
    dump_tokens("MUL\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"/" {
    dump_tokens("DIV\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"%" {
    dump_tokens("MOD\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"&&" {
    dump_tokens("AND\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=2;
}

"||" {
    dump_tokens("OR\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=2;
}

"!" {
    dump_tokens("NOT\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"," {
    dump_tokens("COMMA\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

";" {
    dump_tokens("SEMICOLON\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"(" {
    dump_tokens("LPAREN\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

")" {
    dump_tokens("RPAREN\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"[" {
    dump_tokens("LBRACKET\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"]" {
    dump_tokens("RBRACKET\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"{" {
    stack.push();
    dump_tokens("LBRACE\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

"}" {
    stack.pop();
    dump_tokens("RBRACE\t\t%s\t\t%d\t%d\n", yytext, yylineno, column);
    column+=1;
}

{DECIMIAL} {
    int decimal;
    decimal = atoi(yytext);
    dump_tokens("DECIMAL\t\t%s\t\t%d\t%d\t%d\n", yytext, yylineno, column, decimal);
    column+=strlen(yytext);
}

{OCTAL} {
    int decimal;
    sscanf(yytext, "%o", &decimal);
    dump_tokens("OCTAL\t\t%s\t\t%d\t%d\t%d\n", yytext, yylineno, column, decimal);
    column+=strlen(yytext);
}

{HEXADECIMAL} {
    int decimal;
    sscanf(yytext, "%x", &decimal);
    dump_tokens("HEXADECIMAL\t%s\t\t%d\t%d\t%d\n", yytext, yylineno, column, decimal);
    column+=strlen(yytext);
}

{FLOAT} {
    float floatValue;
    floatValue = atof(yytext);
    dump_tokens("FLOAT\t\t%s\t\t%d\t%d\t%f\n", yytext, yylineno, column, floatValue);
    column += strlen(yytext);
}

{ID} {
    node *address = stack.lookup(yytext);
    dump_tokens("ID\t\t%s\t\t%d\t%d\t0x%x\n", yytext, yylineno, column, address);
    column+=strlen(yytext);
}

{EOL} {
    yylineno++;
    column=1;
}

{WHITE} column++;

{LINECOMMENT} {}   //处理注释，使用定义好的独占状态BLOCKCOMMENT
{BLOCKCOMMENTBEGIN} {BEGIN BLOCKCOMMENT;}
<BLOCKCOMMENT>{BLOCKCOMMENTELEMENT} {}
<BLOCKCOMMENT>{BLOCKCOMMENTEND} {BEGIN INITIAL;} //使用宏BEGIN来切换状态，初始状态默认为INITIAL 

    /*  Your code here (lab3). */
%%
/* user code section */
