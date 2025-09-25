#* -------------------------------------------
   Interactive Calculator
--------------------------------------------- *#

def calc(a: float, op: str, b: float) -> float {
    if op == "add" {
        return a + b;
    } elif op == "sub" {
        return a - b;
    } elif op == "mul" {
        return a * b;
    } elif op == "div" {
        if b == 0 {
            return 0.0;   # avoid division by zero
        }
        return a / b;
    }
    return 0.0;  # unknown operator fallback
}

with entry {
    print("🧮 Jac CLI Calculator");
    print("Type: number operator number   (e.g., 3 add 4)");
    print("Type 'exit' to quit.");

    while True {
        line = input(">> ");     # get user input

        if line == "exit" {
            break;               # exit the loop
        }

        parts = line.split();    # split into words
        if len(parts) != 3 {
            print("Format: a op b   (e.g., 5 add 2)");
            continue;
        }

        a = float(parts[0]);
        op = parts[1];
        b = float(parts[2]);

        result = calc(a, op, b);
        print("=", result);
    }
}
