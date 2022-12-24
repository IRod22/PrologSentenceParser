const fs = require('fs')

/**
 * 
 * @param {string} file
 * @returns {Promise<string>}
 */

const load = file => new Promise((res, rej) => {
    fs.readFile(file, (err, buff) => {
        if (err) rej(err)
        else res(buff.toString('utf-8'))
    })
})

module.exports = {
    load,
}