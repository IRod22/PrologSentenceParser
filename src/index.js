const pl = require('tau-prolog'), { load } = require('./fsutils')
const session = pl.create(1000)
const show = x => console.log('==>', session.format_answer(x))

/**
 * @param {string} pgrm
 * @returns {Promise<void>}
 */
const consult = pgrm => new Promise((res, rej) => {
    session.consult(pgrm, {
        success: res,
        error: rej,
    })
})

/**
 * @param {string} q
 * @returns {Promise<void>}
 */
const query = q => new Promise((res, rej) => {
    session.query(q, {
        success: res,
        error: rej,
    })
})

/**
 * @returns {Promise<{done:boolean, fail?: boolean, res?: any}>}
 */
const ans = () => new Promise((res, rej) => {
    session.answer({
        success: ans => res({done: false, res: ans}),
        error: rej,
        fail: () => res({done: true, fail: true}),
        limit: () => res({done: true}),
    })
})

/**
 * @returns {Promise<any[]>}
 */
const getAnswers = async () => {
    while (true) {
        const res = await ans()
        if (res.done) break
        show(res.res)
    }
}

async function main() {
    const program = await load('./src/grammar.pro')
    const queries = await load('./src/queries.txt')
    await consult(program)
    for (const ln of queries.split('\n')) {
        console.log('<==', ln ? ln : '(empty line)')
        if (!ln.startsWith('%') && ln) {
            await query(ln)
            await getAnswers()
        }
    }
}

main().catch(show)