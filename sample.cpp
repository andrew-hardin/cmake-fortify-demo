int main() {
    int length = 10;
    int* memory = new int[length];
    for(int i = 0; i < length + 1; i++) {
        memory[i] = i;  // out-of-bounds write
    }
    return 0;
    // Memory leak
}