import scriptLoader from 'react-async-script-loader'

const LoadStripe = () => null
export default scriptLoader('https://checkout.stripe.com/checkout.js')(LoadStripe)
