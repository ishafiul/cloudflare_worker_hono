export const generateOtp = (size: number) => {
	const zeros = '0'.repeat(size - 1);
	const x = parseFloat('1' + zeros);
	const y = parseFloat('9' + zeros);
	return String(Math.floor(x + Math.random() * y));
};
