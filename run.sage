if __name__ == "__main__":
    done = {}
    todo = prime_range(20,3000)
    candidates = lower_genus_candidates_parallel(list(todo))
    for p in todo:
        while not (p in done):
            answer = next(candidates)
            done[answer[0][0][0]] = answer[1]
        print(p, done[p])
