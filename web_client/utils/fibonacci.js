// https://gregjs.com/javascript/2016/writing-a-fibonacci-implementation-in-javascript/

let fibLoop = (n, a, b) => n === 0 ? b : fibLoop(n - 1, a + b, a)
export default (n) => fibLoop(n, 1, 0)
